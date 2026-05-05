return {
  "folke/flash.nvim",
  event = "VeryLazy",
  ---@type Flash.Config
  opts = {
    search = {
      multi_window = true, -- Jump across any open window
      wrap = true,         -- Wrap around the buffer
    },
    jump = {
      autojump = true,     -- Automatically jump when only one match remains
    },
    modes = {
      search = {
        enabled = true,    -- Enables flash labels during regular / search
      },
      char = {
        enabled = false    -- Keep standard f/F/t/T behavior
      }
    }
  },
  -- stylua: ignore
  keys = {
    { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash Jump" },
    { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
  },
}
