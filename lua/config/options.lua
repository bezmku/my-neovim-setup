vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.cursorline = true
vim.opt.relativenumber = true

-- Setup consistent 4-space indentation
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

vim.opt.clipboard = "unnamedplus"

-- Ask for confirmation instead of erroring when quitting with unsaved changes
vim.opt.confirm = true


-- Persistent Undo
vim.opt.undofile = true
-- This creates a directory for undo files if it doesn't exist
local undodir = vim.fn.expand("~/.local/state/nvim/undo")
if vim.fn.isdirectory(undodir) == 0 then
    vim.fn.mkdir(undodir, "p")
end
vim.opt.undodir = undodir
vim.opt.undolevels = 1000
vim.opt.undoreload = 10000
