return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
        bigfile = { enabled = true },
        notifier = { enabled = true },
        quickfile = { enabled = true },
        statuscolumn = { enabled = true },
        words = { enabled = true },
        terminal = { enabled = true },
        dashboard = {
            enabled = true,
            preset = {
                header = [[
       ██████╗██╗   ██╗██╗███╗   ███╗          Z
      ██╔════╝██║   ██║██║████╗ ████║      Z
      ██║     ██║   ██║██║██╔████╔██║   z
      ██║     ╚██╗ ██╔╝██║██║╚██╔╝██║ z
      ╚██████╗ ╚████╔╝ ██║██║ ╚═╝ ██║
       ╚═════╝  ╚═══╝  ╚═╝╚═╝     ╚═╝
]],
                keys = {
                    { icon = " ", key = "e", desc = "Open Neo-tree", action = "<cmd>Neotree toggle<cr>" },
                    { icon = " ", key = "f", desc = "Find File", action = ":Telescope find_files" },
                    { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
                    { icon = " ", key = "g", desc = "Find Text", action = ":Telescope live_grep" },
                    { icon = " ", key = "r", desc = "Recent Files", action = ":Telescope oldfiles" },
                    { icon = " ", key = "c", desc = "Config", action = ":Telescope find_files cwd=" .. vim.fn.stdpath("config") },
                    { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
                    { icon = " ", key = "q", desc = "Quit", action = ":qa" },
                },
            },
        },
    },
    keys = {
        {
            "<leader>st",
            function()
                Snacks.terminal(nil,
                    { win = { position = "float", border = "rounded", width = 0.8, height = 0.8, backdrop = 60, wo = { winblend = 10 } } })
            end,
            desc = "Toggle Terminal"
        },
        { "<leader>n",  function() Snacks.notifier.show_history() end, desc = "Notification History" },
        { "<leader>un", function() Snacks.notifier.hide() end,         desc = "Dismiss All Notifications" },
    },
}
