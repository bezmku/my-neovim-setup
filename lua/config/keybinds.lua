vim.g.mapleader = " "

--key binds for entering normal mode and opening file window
vim.keymap.set("n", "<leader>cd", vim.cmd.Ex)
vim.keymap.set("i", "jj", "<Esc>", { desc = "Exit insert mode with jj" })

-- Manual Format Shortcut 
vim.keymap.set("n", "<leader>f", function()
    vim.lsp.buf.format({ async = true })
end, { desc = "Format current buffer" })

