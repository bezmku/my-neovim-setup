return {
    "ziontee113/color-picker.nvim",
    config = function()
        require("color-picker").setup({
            -- for changing icons & mappings
            -- ["icons"] = { "ﱢ", "" },
            -- ["icons"] = { "", "" },
            ["icons"] = { "■", "▼" },
            ["border"] = "rounded", -- none | single | double | rounded | solid | shadow
            ["keymap"] = { -- mapping example:
                ["U"] = "<C-u>",
                ["D"] = "<C-d>",
                ["R"] = "<C-r>",
                ["a"] = "<M-a>",
            },
            ["background_highlight_group"] = "Normal", -- default
            ["hex_default_format"] = "hex", -- "hex" | "css"
        })
        
        -- Keybindings
        vim.keymap.set("n", "<leader>cp", "<cmd>PickColor<CR>", { desc = "Color Picker" })
        vim.keymap.set("i", "<C-p>", "<cmd>PickColorInsert<CR>", { desc = "Color Picker Insert" })
    end,
}
