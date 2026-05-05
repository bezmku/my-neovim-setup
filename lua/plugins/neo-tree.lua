return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    cmd = "Neotree",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
        {
            's1n7ax/nvim-window-picker',
            version = '2.*',
            config = function()
                require('window-picker').setup({
                    filter_rules = {
                        include_current_win = false,
                        autoselect_one = true,
                        bo = {
                            filetype = { 'neo-tree', "neo-tree-popup", "notify" },
                            buftype = { 'terminal', "quickfix" },
                        },
                    },
                })
            end,
        },
    },
    keys = {
        { "<leader>ee", "<cmd>Neotree toggle<cr>", desc = "Toggle Explorer" },
        { "<leader>ef", "<cmd>Neotree focus filesystem left<cr>", desc = "Focus Files" },
        { "<leader>eb", "<cmd>Neotree focus buffers left<cr>", desc = "Focus Buffers" },
        { "<leader>eg", "<cmd>Neotree focus git_status left<cr>", desc = "Focus Git" },
    },
    opts = {
        close_if_last_window = true,
        popup_border_style = "rounded",
        enable_git_status = true,
        enable_diagnostics = true,

        source_selector = {
            sources = {
                { source = "filesystem", display_name = " 󰉓 Files " },
                { source = "buffers", display_name = " 󰈙 Buffers " },
                { source = "git_status", display_name = " 󰊢 Git " },
            },
            content_layout = "center",
            tabs_layout = "equal",
            show_separator_on_edge = true,
            padding_left = 1,
            padding_right = 1,
        },

        default_component_configs = {
            indent = {
                indent_size = 2,
                padding = 1,
                with_markers = true,
                indent_marker = "│",
                last_indent_marker = "└",
                highlight = "NeoTreeIndentMarker",
                with_expanders = true,
                expander_collapsed = "",
                expander_expanded = "",
                expander_highlight = "NeoTreeExpander",
            },
            icon = {
                folder_closed = "󰉓",
                folder_open = "󱗗",
                folder_empty = "󰜌",
                folder_empty_open = "󰷏",
                default = "󰈚",
                highlight = "NeoTreeFileIcon",
            },
            modified = {
                symbol = "●",
                highlight = "NeoTreeModified",
            },
            name = {
                trailing_slash = false,
                use_git_status_colors = true,
                highlight = "NeoTreeFileName",
            },
            git_status = {
                symbols = {
                    added     = "󰐕",
                    modified  = "󰏫",
                    deleted   = "󰍶",
                    renamed   = "󰁕",
                    untracked = "󰔓",
                    ignored   = "󰛐",
                    unstaged  = "󰄱",
                    staged    = "󰄲",
                    conflict  = "󰀦",
                },
            },
        },

        window = {
            width = 35,
            auto_expand_width = false,
            padding_left = 1,
            padding_right = 1,
            mappings = {
                ["l"] = "open",
                ["h"] = "close_node",
                ["<S-l>"] = "next_source",
                ["<S-h>"] = "prev_source",
                ["d"] = "delete",
                ["Z"] = function(state)
                    local node = state.tree:get_node()
                    local path = node:get_id()
                    if path:match("%.zip$") then
                        local dest = path:gsub("%.zip$", "")
                        vim.fn.system(string.format("unzip -o %s -d %s", vim.fn.shellescape(path), vim.fn.shellescape(dest)))
                        vim.notify("Unzipped: " .. dest, vim.log.levels.INFO)
                        require("neo-tree.sources.manager").refresh(state.name)
                    else
                        vim.notify("Node is not a zip file", vim.log.levels.WARN)
                    end
                end,
                ["<space>"] = "none",
                ["o"] = function(state)
                    local node = state.tree:get_node()
                    if node.type == "directory" then
                        require("neo-tree.ui.renderer").toggle_node(state)
                    else
                        require("neo-tree.ui.renderer").toggle_node(state)
                    end
                end,
            },
        },

        filesystem = {
            filtered_items = {
                visible = true,
                hide_dotfiles = false,
                hide_gitignored = false,
                hide_by_name = {
                    "node_modules",
                    ".cache",
                    "dist",
                },
                never_show_by_pattern = {
                    ".DS_Store",
                    "thumbs.db",
                },
            },
            follow_current_file = {
                enabled = true,
                leave_dirs_open = false,
            },
            use_libuv_file_watcher = true,
            hijack_netrw_behavior = "open_default",
            bind_to_cwd = false,
            cwd_target = {
                sidebar = "tab",
                current = "window",
            },
            group_empty_dirs = true,
        },

        buffers = {
            follow_current_file = {
                enabled = true,
                leave_dirs_open = false,
            },
            group_empty_dirs = true,
            show_unloaded = true,
            window = {
                position = "left",
            },
        },

        git_status = {
            follow_current_file = {
                enabled = true,
                leave_dirs_open = false,
            },
            group_empty_dirs = true,
            window = {
                position = "left",
            },
        },

        event_handlers = {
            {
                event = "neo_tree_buffer_enter",
                handler = function(_)
                    vim.opt_local.signcolumn = "auto"
                    vim.opt_local.cursorline = true
                end,
            },
        },
    },
    config = function(_, opts)
        require("neo-tree").setup(opts)

        vim.api.nvim_set_hl(0, "NeoTreeDirectoryName", { fg = "#89b4fa", bold = true })
        vim.api.nvim_set_hl(0, "NeoTreeDimText", { fg = "#585b70", italic = true })
        vim.api.nvim_set_hl(0, "NeoTreeFileName", { fg = "#cdd6f4" })
        vim.api.nvim_set_hl(0, "NeoTreeFileTitle", { fg = "#f38ba8", bold = true })
        vim.api.nvim_set_hl(0, "NeoTreeSourceName", { fg = "#a6adc8", bold = true })
        vim.api.nvim_set_hl(0, "NeoTreeTabActive", { fg = "#1e1e2e", bg = "#89b4fa", bold = true })
        vim.api.nvim_set_hl(0, "NeoTreeTabInactive", { fg = "#a6adc8", bg = "#313244" })
        vim.api.nvim_set_hl(0, "NeoTreeTabSeparatorActive", { fg = "#89b4fa", bg = "#89b4fa" })
        vim.api.nvim_set_hl(0, "NeoTreeTabSeparatorInactive", { fg = "#313244", bg = "#313244" })
        vim.api.nvim_set_hl(0, "NeoTreeNormal", { bg = "none" })
        vim.api.nvim_set_hl(0, "NeoTreeNormalNC", { bg = "none" })
        vim.api.nvim_set_hl(0, "NeoTreeWinSeparator", { fg = "#313244", bg = "none" })
        vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#313244", bg = "none" })
    end,
}
