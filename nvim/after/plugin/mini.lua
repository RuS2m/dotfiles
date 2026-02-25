require('mini.icons').setup({ style = 'glyph' })

require('mini.tabline').setup({
    show_icons = true,
    format = function(buffer_id, label)
      -- don't show unlisted buffers
      if not vim.bo[buffer_id].buflisted then return '' end
      -- including path abbreveation in the tab name
      local name = vim.api.nvim_buf_get_name(buffer_id)
      if name == '' then -- handling empty tab edge case
          name = '[No Name]'
      else
          -- abbreviate each directory component to first letter
          name = name:gsub('([^/]+)/', function(s) return s:sub(1, 1) .. '/' end) -- take first element of every part of the path beside last
      end

      local suffix = vim.bo[buffer_id].modified and '+ ' or '' -- + if the buffer was modified
      return MiniTabline.default_format(buffer_id, name) .. suffix
    end,
    tabpage_section = 'left',
})
