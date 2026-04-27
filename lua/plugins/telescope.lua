return {
    'nvim-telescope/telescope.nvim',
    -- Removed the tag to let it use the latest version with this workaround
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
        local telescope = require('telescope')
        local builtin = require('telescope.builtin')
        local actions = require('telescope.actions')

        telescope.setup({
            defaults = {
                mappings = {
                    n = {
                        ["q"] = actions.close
                    }
                },
                -- THE FIX: This stops Telescope from trying to 'color' the preview
                -- which is what causes the 'ft_to_lang' crash in Nvim 0.12.0
                preview = {
                    treesitter = false,
                },
                file_ignore_patterns = { "target/.*", "%.class", ".git/.*" },
                path_display = { "truncate" },
            }
        })

        -- Your Keybindings
        vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
        vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
        vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
        vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
    end
}
