return {
    "nickjvandyke/opencode.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons",
    },
    event = "VeryLazy",
    config = function()
        -- opencode.nvim uses vim.g.opencode_opts instead of a setup() function
        vim.g.opencode_opts = {
            server = {
                api_url = "http://localhost:8080",
            },
        }

        -- Custom Keybindings using the Lua API
        vim.keymap.set("n", "<leader>os", function() require("opencode").start() end, { desc = "Start OpenCode Server" })
        vim.keymap.set("n", "<leader>ot", function() require("opencode").toggle() end, { desc = "Toggle OpenCode Window" })
        vim.keymap.set("n", "<leader>oq", function() require("opencode").stop() end, { desc = "Stop OpenCode Server" })
        vim.keymap.set("n", "<leader>oc", function() require("opencode").ask() end, { desc = "OpenCode Chat" })
        vim.keymap.set("n", "<leader>oa", function() require("opencode").select() end, { desc = "OpenCode Actions" })
    end,
}
