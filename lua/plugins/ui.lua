return {
    -- Better UI for messages, cmdline and popupmenu
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        opts = {
            lsp = {
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.set_formatting_op"] = true,
                    ["classic_lsp_notifications"] = false,
                },
            },
            presets = {
                bottom_search = true,
                command_palette = false,
                long_message_to_split = true,
                inc_rename = false,
                lsp_doc_border = true,
            },
        },
        dependencies = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        },
    },
    -- Beautiful notifications
    {
        "rcarriga/nvim-notify",
        opts = {
            timeout = 3000,
            background_colour = "#000000",
            render = "compact",
        },
    },
    -- Better UI for inputs and selects
    {
        "stevearc/dressing.nvim",
        lazy = true,
        init = function()
            ---@diagnostic disable-next-line: duplicate-set-field
            vim.ui.select = function(...)
                require("lazy").load({ plugins = { "dressing.nvim" } })
                return vim.ui.select(...)
            end
            ---@diagnostic disable-next-line: duplicate-set-field
            vim.ui.input = function(...)
                require("lazy").load({ plugins = { "dressing.nvim" } })
                return vim.ui.input(...)
            end
        end,
        opts = {
            select = {
                backend = { "telescope", "builtin" },
                telescope = {
                    layout_config = {
                        width = 0.5,
                        height = 0.4,
                    },
                },
            },
        },
    },
    -- Indentation guides
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        config = function()
            local hooks = require("ibl.hooks")
            -- create the highlight groups in the HIGHLIGHT_SETUP hook, so they are reset
            -- every time the colorscheme changes
            hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
                vim.api.nvim_set_hl(0, "IblIndent", { fg = "#3b4261" })
                vim.api.nvim_set_hl(0, "IblScope", { fg = "#7aa2f7" })
            end)

            require("ibl").setup({
                indent = { highlight = "IblIndent" },
                scope = { highlight = "IblScope" },
            })
        end,
    },
    -- Premium Inline Renaming
    {
        "smjonas/inc-rename.nvim",
        cmd = "IncRename",
        opts = {
            input_buffer_type = "dressing",
        },
    },
}
