return {
  "nvimdev/dashboard-nvim",
  event = "VimEnter",
  dependencies = { {"nvim-tree/nvim-web-devicons"} },
  config = function()
    local logo = {
      [[                               __                ]],
      [[  ___     ___    ___   __  __ /\_\    ___ ___    ]],
      [[ / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\  ]],
      [[/\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \ ]],
      [[\ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\]],
      [[ \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/]],
      [[                                                 ]],
    }

    require("dashboard").setup({
      theme = "doom",
      config = {
        header = logo,
        center = {
          { action = "Telescope find_files", desc = " Find file", icon = " ", key = "f" },
          { action = "Neotree toggle",       desc = " Explorer",  icon = " ", key = "e" },
          { action = "Telescope live_grep",  desc = " Find text", icon = " ", key = "g" },
          { action = "qa",                   desc = " Quit",      icon = " ", key = "q" },
        },
        footer = function()
          local stats = require("lazy").stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
          return { "⚡ Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms" }
        end,
      },
    })
  end,
}
