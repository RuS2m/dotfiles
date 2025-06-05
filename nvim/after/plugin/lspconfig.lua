-- lsp server ported from rust-analyzer
local nvim_lsp = require('lspconfig')

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
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'wf', '<cmd>lua vim.lsp.buf.format({ async = true })<CR>', opts)
  vim.api.nvim_command('autocmd CursorHold <buffer> lua vim.diagnostic.open_float(nil, { focusable = false })')
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-y>', '<cmd>lua vim.diagnostic.open_float(nil, { focusable = false })<CR>', opts)
end

nvim_lsp.rust_analyzer.setup({
  on_attach = on_attach,
  root_dir = require('lspconfig.util').root_pattern("Cargo.toml"),
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
              loadOutDirsFromCheck = true,
          }
    },
  },
})

nvim_lsp.clangd.setup({
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
