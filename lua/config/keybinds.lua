vim.g.mapleader = " "

--key binds for entering normal mode and opening file window
vim.keymap.set("n", "<leader>cd", vim.cmd.Ex)
vim.keymap.set("i", "jj", "<Esc>", { desc = "Exit insert mode with jj" })

-- Manual Format Shortcut 
vim.keymap.set("n", "<leader>f", function()
    vim.lsp.buf.format({ async = true })
end, { desc = "Format current buffer" })

-- Window Navigation (Switch between splits easily)
vim.keymap.set("n", "<leader>hh", "<C-w>h", { desc = "Go to left window" })
vim.keymap.set("n", "<leader>jj", "<C-w>j", { desc = "Go to lower window" })
vim.keymap.set("n", "<leader>kk", "<C-w>k", { desc = "Go to upper window" })
vim.keymap.set("n", "<leader>ll", "<C-w>l", { desc = "Go to right window" })

-- Window Resizing (Shrink/Minimize or Grow windows)
vim.keymap.set("n", "<leader><Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
vim.keymap.set("n", "<leader><Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
vim.keymap.set("n", "<leader><Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
vim.keymap.set("n", "<leader><Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- Window Zoom (Maximize current split without closing others)
local zoomed = false
vim.keymap.set("n", "<leader>z", function()
    if zoomed then
        vim.cmd("wincmd =")
        zoomed = false
    else
        vim.cmd("wincmd |")
        vim.cmd("wincmd _")
        zoomed = true
    end
end, { desc = "Toggle Window Zoom" })

-- Window Minimize & Restore
local minimized_bufs = {}

vim.keymap.set("n", "<leader>m", function()
    -- Only minimize if there's more than one window open
    if #vim.api.nvim_tabpage_list_wins(0) > 1 then
        local buf = vim.api.nvim_get_current_buf()
        table.insert(minimized_bufs, buf)
        vim.cmd("hide")
        print("Split minimized")
    else
        print("Cannot minimize the last window!")
    end
end, { desc = "Minimize split" })

vim.keymap.set("n", "<leader>M", function()
    if #minimized_bufs > 0 then
        -- Keep popping from the stack until we find a valid buffer, or run out
        while #minimized_bufs > 0 do
            local buf = table.remove(minimized_bufs)
            if vim.api.nvim_buf_is_valid(buf) then
                vim.cmd("vsplit")
                vim.api.nvim_win_set_buf(0, buf)
                print("Split restored")
                return
            end
        end
        print("No valid minimized splits to restore")
    else
        print("No minimized split to restore")
    end
end, { desc = "Restore minimized split" })
