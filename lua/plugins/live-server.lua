return {
    "hyperstown/nvim-live-server",
    cmd = { "LiveServerStart", "LiveServerStop", "LiveServerToggle" },
    opts = {
        host = "127.0.0.1",
        port = 8080,
        open_browser = true,      -- Automatically opens browser when server starts
        bind_attempts = 3,        -- Try 3 ports if 8080 is busy
    },
    keys = {
        { "<leader>ls", "<cmd>LiveServerStart<CR>", desc = "Start Live Server" },
        { "<leader>lt", "<cmd>LiveServerToggle<CR>", desc = "Toggle Live Server" },
        { "<leader>lS", "<cmd>LiveServerStop<CR>", desc = "Stop Live Server" },
    },
}
