-- gitsigns settings
local gitsigns = require('gitsigns')

local on_attach = function(bufnr)
    require('gitsigns')
    -- navigate
    vim.keymap.set('n', ']c', function()
      if vim.wo.diff then
        vim.cmd.normal({']c', bang = true})
      else
        gitsigns.nav_hunk('next')
      end
    end, opts)
    vim.keymap.set('n', '[c', function()
      if vim.wo.diff then
        vim.cmd.normal({'[c', bang = true})
      else
        gitsigns.nav_hunk('prev')
      end
    end, opts)
    -- blame line
    vim.keymap.set('n', '<C-b>', ':Gitsigns blame<CR>')

    -- stage/reset hunk
    vim.keymap.set('n', '<C-s>', gitsigns.stage_hunk, opts)
    vim.keymap.set('n', '<C-r>', gitsigns.reset_hunk, opts)

    vim.keymap.set('v', '<C-s>', function()
      gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
    end, opts)

    vim.keymap.set('v', '<C-r>', function()
      gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
    end, opts)
    -- preview hunk
    vim.keymap.set('n', '<C-p>', gitsigns.preview_hunk_inline, opts)
end

gitsigns.setup({
    on_attach = on_attach,
})
