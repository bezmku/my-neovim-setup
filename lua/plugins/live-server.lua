return {
    "hyperstown/nvim-live-server",
    cmd = { "LiveServerStart", "LiveServerStop", "LiveServerToggle" },
    opts = {
        host = "127.0.0.1",
        port = 5500,        -- Using 5500 to keep port 8080 free for Tomcat
        open_browser = false, -- We handle opening the browser ourselves below
    },
    keys = {
        {
            "<leader>ls",
            function()
                -- 1. Get the path of the current file relative to where you opened nvim
                -- If you are in webapp/ and edit home.html, this is "home.html"
                -- If you are in QuizSystem/ and edit src/main/webapp/home.html, this is the full path
                local relative_path = vim.fn.expand("%")
                
                -- 2. Start the server
                vim.cmd("LiveServerStart")
                
                -- 3. Wait 500ms for server to boot, then open the specific file
                vim.defer_fn(function()
                    local url = "http://127.0.0.1:5500/" .. relative_path
                    -- xdg-open is the command for Ubuntu/Linux to open a link
                    vim.fn.jobstart({ "xdg-open", url })
                    print("Live Server started at: " .. url)
                end, 500)
            end,
            desc = "Start Live Server for current file",
        },
        { "<leader>lS", "<cmd>LiveServerStop<CR>", desc = "Stop Live Server" },
        { "<leader>lt", "<cmd>LiveServerToggle<CR>", desc = "Toggle Live Server" },
    },
}
