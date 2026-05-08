return {
  "karb94/neoscroll.nvim",
  config = function()
    local neoscroll = require('neoscroll')
    neoscroll.setup({
      mappings = {'<C-u>', '<C-d>', '<C-b>', '<C-f>',
                  '<C-y>', '<C-e>', 'zt', 'zz', 'zb'},
      hide_cursor = true,
      stop_eof = true,
      respect_scrolloff = false,
      cursor_scroll_step = 1,
      easing_function = "quadratic",
    })

    -- Define custom scrolling for Alt keys with a short duration for continuous feel
    local keymap = {
      ["<A-d>"] = function() neoscroll.ctrl_d({ duration = 150 }) end,
      ["<A-u>"] = function() neoscroll.ctrl_u({ duration = 150 }) end,
    }

    local modes = { 'n', 'v', 'x' }
    for key, func in pairs(keymap) do
      for _, mode in ipairs(modes) do
        vim.keymap.set(mode, key, func)
      end
    end
  end
}
