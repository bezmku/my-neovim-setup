return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local harpoon = require("harpoon")
        harpoon:setup()

        -- Add current file to harpoon list
        vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end, 
            { desc = "Add file to harpoon" })

        -- Remove current file from harpoon list
        vim.keymap.set("n", "<leader>d", function() 
            harpoon:list():remove()
            vim.notify("Removed current file from harpoon", "info", { title = "Harpoon" })
        end, { desc = "Remove current file from harpoon" })

        -- Toggle the harpoon menu
        vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, 
            { desc = "Toggle harpoon menu" })

        -- Navigate through harpoon files
        vim.keymap.set("n", "<leader>n", function() harpoon:list():next() end, 
            { desc = "Go to next harpoon file" })
        vim.keymap.set("n", "<leader>p", function() harpoon:list():prev() end, 
            { desc = "Go to previous harpoon file" })
    end,
}
