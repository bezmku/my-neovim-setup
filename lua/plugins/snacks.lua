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
    },
    keys = {
        { "<leader>st", function() Snacks.terminal(nil, { win = { position = "float", border = "rounded", width = 0.8, height = 0.8, backdrop = 60, wo = { winblend = 10 } } }) end, desc = "Toggle Terminal" },
        { "<leader>n", function() Snacks.notifier.show_history() end, desc = "Notification History" },
        { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
    },
}
