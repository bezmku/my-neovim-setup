return {
    -- Virtual Environment Selector
    {
        "linux-cultist/venv-selector.nvim",
        branch = "regexp", -- Use modern branch for stability
        dependencies = {
            "neovim/nvim-lspconfig",
            "nvim-telescope/telescope.nvim",
            "mfussenegger/nvim-dap-python",
        },
        opts = {
            settings = {
                options = {
                    notify_user_on_venv_activation = true,
                },
            },
        },
        keys = {
            { "<leader>pv", "<cmd>VenvSelect<cr>", desc = "Select VirtualEnv" },
        },
    },

    -- Testing Framework
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-neotest/nvim-nio",
            "nvim-lua/plenary.nvim",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-treesitter/nvim-treesitter",
            "nvim-neotest/neotest-python",
        },
        config = function()
            require("neotest").setup({
                adapters = {
                    require("neotest-python")({
                        dap = { justMyCode = false },
                    }),
                },
            })
        end,
        keys = {
            { "<leader>pt", function() require("neotest").run.run() end, desc = "Run Nearest Test" },
            { "<leader>pT", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run File Tests" },
            { "<leader>ps", function() require("neotest").summary.toggle() end, desc = "Test Summary" },
        },
    },

    -- Docstring Generation
    {
        "danymat/neogen",
        dependencies = "nvim-treesitter/nvim-treesitter",
        opts = {
            enabled = true,
            languages = {
                python = {
                    template = {
                        annotation_convention = "google",
                    },
                },
            },
        },
        keys = {
            { "<leader>pd", function() require("neogen").generate() end, desc = "Generate Docstring" },
        },
    },

    -- Refactoring Tools
    {
        "ThePrimeagen/refactoring.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
        opts = {},
        keys = {
            { "<leader>pr", function() require("refactoring").select_refactor() end, mode = "v", desc = "Refactor Menu" },
        },
    },

    -- Interactive Coding (Jupyter-like)
    {
        "benlubas/molten-nvim",
        version = "^1.0.0", -- use version <2.0.0 to avoid breaking changes
        build = ":UpdateRemotePlugins",
        init = function()
            -- these are mapped to <leader>pi (Python Interactive)
            vim.g.molten_output_win_max_height = 20
        end,
        keys = {
            { "<leader>pi", "<cmd>MoltenInit<cr>", desc = "Initialize Molten" },
            { "<leader>pe", "<cmd>MoltenEvaluateOperator<cr>", desc = "Evaluate Operator" },
            { "<leader>pl", "<cmd>MoltenEvaluateLine<cr>", desc = "Evaluate Line" },
            { "<leader>ph", "<cmd>MoltenHideOutput<cr>", desc = "Hide Molten Output" },
            { "<leader>ps", "<cmd>MoltenShowOutput<cr>", desc = "Show Molten Output" },
        },
    },
}
