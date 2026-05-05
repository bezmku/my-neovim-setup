return {
    -- 1. Rainbow Delimiters (Colorful brackets)
    {
        "hiphish/rainbow-delimiters.nvim",
        config = function()
            local rb = require("rainbow-delimiters")
            vim.g.rainbow_delimiters = {
                strategy = {
                    [''] = rb.strategy['global'],
                },
                query = {
                    [''] = 'rainbow-delimiters',
                },
                highlight = {
                    'RainbowDelimiterRed',
                    'RainbowDelimiterYellow',
                    'RainbowDelimiterBlue',
                    'RainbowDelimiterOrange',
                    'RainbowDelimiterGreen',
                    'RainbowDelimiterViolet',
                    'RainbowDelimiterCyan',
                },
            }
        end,
    },

    -- 2. Treesitter Context (Pinned headers when scrolling)
    {
        "nvim-treesitter/nvim-treesitter-context",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        config = function()
            require("treesitter-context").setup({
                enable = true,
                max_lines = 3,
                min_window_height = 0,
                line_numbers = true,
                multiline_threshold = 20,
                trim_scope = 'outer',
                mode = 'cursor',
                separator = nil,
                zindex = 20,
            })
            -- Map to jump to context
            vim.keymap.set("n", "[c", function()
                require("treesitter-context").go_to_context()
            end, { silent = true, desc = "Jump to context" })
        end,
    },
}
