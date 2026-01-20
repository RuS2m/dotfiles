-- lsp server settings
local nvim_lsp = require('lspconfig')

-- clang-specific magic, due to work with header files
-- https://clangd.llvm.org/extensions.html#switch-between-sourceheader
local function switch_source_header(bufnr, client)
  local method_name = 'textDocument/switchSourceHeader'
  ---@diagnostic disable-next-line:param-type-mismatch
  if not client or not client:supports_method(method_name) then
    return vim.notify(('method %s is not supported by any servers active on the current buffer'):format(method_name))
  end
  local params = vim.lsp.util.make_text_document_params(bufnr)
  ---@diagnostic disable-next-line:param-type-mismatch
  client:request(method_name, params, function(err, result)
    if err then
      error(tostring(err))
    end
    if not result then
      vim.notify('corresponding file cannot be determined')
      return
    end
    vim.cmd.edit(vim.uri_to_fname(result))
  end, bufnr)
end

-- unified lsp mappings
local on_attach = function(client, bufnr)
  local opts = { noremap=true, silent=true }
  -- enable logging
  --[[
  client.config.flags = {
      allow_incremental_sync = true,
      debounce_text_changes = 150,
  }
  client.config.cmd_env = {
      RUST_LOG = "debug",
      RUST_BACKTRACE = "full",
  }
  --]]
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>tab split | lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  --vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.keymap.set("n", "K", function()
    vim.lsp.buf.hover()
    -- hover is async; wait a tick then focus the newest float
    vim.defer_fn(function()
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        local cfg = vim.api.nvim_win_get_config(win)
        if cfg and cfg.relative ~= "" then
          pcall(vim.api.nvim_set_current_win, win)
          break
        end
      end
    end, 60)
  end, { buffer = bufnr, silent = true, desc = "LSP hover (focus float)" })
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'wf', '<cmd>lua vim.lsp.buf.format({ async = true })<CR>', opts)
  vim.api.nvim_command('autocmd CursorHold <buffer> lua vim.diagnostic.open_float(nil, { focusable = false })')
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-y>', '<cmd>lua vim.diagnostic.open_float(nil, { focusable = false })<CR>', opts)
  vim.api.nvim_buf_create_user_command(bufnr, 'LspClangdSwitchSourceHeader', function()
      switch_source_header(bufnr, client)
    end, { desc = 'Switch between source/header' })
end

vim.lsp.config('rust_analyzer', {
  on_attach = on_attach,
  settings = {
      ["rust-analyzer"] = {
          assist = {
            importMergeBehavior = "last",
            importPrefix = "by_self",
          },
          diagnostics = {
            enable = true,
            disable = { "unresolved-import" },
          },           
          procMacro = {
              enable = true,
          },
          checkOnSave = {
              command = "clippy",
          },
          cargo = {
              features = "all",
          }
    },
  },
})

vim.lsp.enable('rust_analyzer')
vim.lsp.config('clangd', {
  on_attach = on_attach,
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    "--pch-storage=memory",
    "--all-scopes-completion",
    "--pretty",
    "--header-insertion=never",
    "-j=64",
    "--header-insertion-decorators",
    "--function-arg-placeholders",
    "--completion-style=detailed",
  },
})
vim.lsp.enable('clangd')
