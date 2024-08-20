-- lsp server ported from rust-analyzer
local nvim_lsp = require('lspconfig')

nvim_lsp.rust_analyzer.setup({
  on_attach = function(client, bufnr)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>tab split | lua vim.lsp.buf.definition()<CR>', { noremap=true, silent=true })
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', { noremap=true, silent=true })
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', { noremap=true, silent=true })
        vim.api.nvim_buf_set_keymap(bufnr, 'n', 'wf', '<cmd>lua vim.lsp.buf.format({ async = true })<CR>', { noremap=true, silent=true })

    vim.api.nvim_command('autocmd CursorHold <buffer> lua vim.diagnostic.open_float(nil, { focusable = false })')
  end,

  settings = {
      ["rust-analyzer"] = {
          assist = {
            importMergeBehavior = "last",
            importPrefix = "by_self",
          },
          diagnostics = {
            disabled = { "unresolved-import" }
          },           
          procMacro = {
              enable = true
          },
          checkOnSave = {
              command = "clippy"
          },
    },
  },
})
