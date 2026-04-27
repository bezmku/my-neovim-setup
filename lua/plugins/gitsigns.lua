return {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
        signs = {
            add          = { text = '┃' },
            change       = { text = '┃' },
            delete       = { text = '_' },
            topdelete    = { text = '‾' },
            changedelete = { text = '~' },
            untracked    = { text = '┆' },
        },
        signs_staged = {
            add          = { text = '┃' },
            change       = { text = '┃' },
            delete       = { text = '_' },
            topdelete    = { text = '‾' },
            changedelete = { text = '~' },
            untracked    = { text = '┆' },
        },
        signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
        numhl      = false, -- Toggle with `:Gitsigns toggle_numhl`
        linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
        word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
        watch_gitdir = {
            follow_files = true
        },
        auto_attach = true,
        attach_to_untracked = false,
        current_line_blame = true, -- Toggles git blame line
        current_line_blame_opts = {
            virt_text = true,
            virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
            delay = 1000,
            ignore_whitespace = false,
            virt_text_priority = 100,
        },
        current_line_blame_formatter = '<author>, <author_time:%R> - <summary>',
        sign_priority = 6,
        update_debounce = 100,
        status_formatter = nil, -- Use default
        max_file_length = 40000, -- Disable if file is longer than this (in lines)
        preview_config = {
            -- Options passed to nvim_open_win
            border = 'rounded',
            style = 'minimal',
            relative = 'cursor',
            row = 0,
            col = 1
        },
    },
    config = function(_, opts)
        require('gitsigns').setup(opts)

        -- Add Which-Key group for Git
        local wk_ok, wk = pcall(require, "which-key")
        if wk_ok then
            wk.add({
                { "<leader>g", group = "git" },
            })
        end

        local gs = require('gitsigns')

        -- Keymaps
        vim.keymap.set('n', '<leader>gp', gs.preview_hunk, { desc = "Preview Git Hunk" })
        vim.keymap.set('n', '<leader>gb', function() gs.blame_line{full=true} end, { desc = "Blame Line" })
        vim.keymap.set('n', '<leader>gd', gs.diffthis, { desc = "Git Diff" })
        
        -- Navigation
        vim.keymap.set('n', ']c', function()
            if vim.wo.diff then
                vim.cmd.normal({']c', bang = true})
            else
                gs.nav_hunk('next')
            end
        end, { desc = "Next Git Hunk" })

        vim.keymap.set('n', '[c', function()
            if vim.wo.diff then
                vim.cmd.normal({'[c', bang = true})
            else
                gs.nav_hunk('prev')
            end
        end, { desc = "Prev Git Hunk" })
    end
}
