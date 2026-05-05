return {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    opts = {
        options = {
            mode = "buffers",
            separator_style = "thick",
            always_show_bufferline = true,
            show_buffer_icons = true,
            show_buffer_close_icons = true,
            show_close_icon = true,
            color_icons = true,
            buffer_close_icon = '󰅖',
            modified_icon = '●',
            close_icon = '',
            left_trunc_marker = '',
            right_trunc_marker = '',
            diagnostics = "nvim_lsp",
            diagnostics_indicator = function(count, level, diagnostics_dict, context)
                local icon = level:match("error") and " " or " "
                return " " .. icon .. count
            end,
            tab_size = 20,
            max_name_length = 30,
            indicator = {
                icon = '▎',
                style = 'icon',
            },
        },
    },
    keys = {
        { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Buffer" },
        { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
        { "<leader>bp", "<cmd>BufferLinePick<cr>", desc = "Pick Buffer" },
        { "<leader>bc", "<cmd>bdelete<cr>", desc = "Close Buffer" },
        { "<leader>bt", function()
            if vim.opt.showtabline:get() == 2 then
                vim.opt.showtabline = 0
            else
                vim.opt.showtabline = 2
            end
        end, desc = "Toggle Bufferline" },
    },
}
