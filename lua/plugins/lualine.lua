return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        require("lualine").setup({
            options = {
                theme = "auto", -- Automatically matches your current colorscheme
                component_separators = { left = '', right = ''},
                section_separators = { left = '', right = ''},
                globalstatus = true, -- Uses one statusline for all splits instead of one for each
            },
            sections = {
                lualine_a = {'mode'},
                lualine_b = {'branch', 'diff', 'diagnostics'},
                lualine_c = {'filename'},
                lualine_x = {'encoding', 'fileformat', 'filetype'},
                lualine_y = {'progress'},
                lualine_z = {'location'}
            },
        })
    end,
}
