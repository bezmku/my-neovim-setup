return {
    "okuuva/auto-save.nvim",
    config = function()
        require("auto-save").setup({
            enabled = true,
            -- Save when you stop typing OR when text changes
            trigger_events = { "InsertLeave", "TextChanged" },
            -- Only auto-save HTML files
            condition = function(buf)
                local filetype = vim.bo[buf].filetype
                return filetype == "html"
            end,
            -- Save immediately (no delay)
            debounce_delay = 0,
            write_all_buffers = false,
        })

        -- Toggle auto-save with <leader>as
        vim.keymap.set("n", "<leader>as", ":ASToggle<CR>", { desc = "Toggle Auto-Save" })
    end,
}
