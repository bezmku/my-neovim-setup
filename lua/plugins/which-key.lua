return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
        -- v3 API: 'win' replaces the old 'window' key
        win = {
            border   = "rounded",
            padding  = { 1, 2 },  -- { top/bottom, left/right }
            wo = { winblend = 0 },
        },
        layout = {
            width  = { min = 20 },
            spacing = 3,
        },
        -- 'delay' replaces vim.o.timeoutlen inside opts in v3
        delay = 300,
    },
    config = function(_, opts)
        local wk = require("which-key")
        wk.setup(opts)

        -- Group labels shown in the which-key popup
        wk.add({
            { "<leader>f",  group = "file / find"       },
            { "<leader>b",  group = "buffer"             },
            { "<leader>e",  group = "explorer / extract" },
            { "<leader>l",  group = "live-server / lsp"  },
            { "<leader>p",  group = "python"             },
            { "<leader>t",  group = "theme"              },
        })
    end,
}
