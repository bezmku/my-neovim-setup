return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "hrsh7th/nvim-cmp",
    "nvim-telescope/telescope.nvim",
    { "stevearc/dressing.nvim", opts = {} },
  },
  config = function()
    require("codecompanion").setup({
      strategies = {
        chat = {
          adapter = "ollama",
        },
        inline = {
          adapter = "ollama",
        },
        agent = {
          adapter = "ollama",
        },
      },
      adapters = {
        ollama = function()
          return require("codecompanion.adapters").extend("ollama", {
            schema = {
              model = {
                default = "qwen2.5-coder:7b",
              },
              num_ctx = {
                default = 16384,
              },
            },
          })
        end,
        groq = function()
          return require("codecompanion.adapters").extend("groq", {
            env = {
              api_key = "GROQ_KEY", 
            },
            schema = {
              model = {
                default = "llama-3.3-70b-versatile",
              },
            },
          })
        end,
      },
    })

    -- Keybinds
    vim.keymap.set({ "n", "v" }, "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", { desc = "AI Chat" })
    vim.keymap.set({ "n", "v" }, "<leader>aa", "<cmd>CodeCompanionActions<cr>", { desc = "AI Actions" })
    vim.keymap.set("v", "ga", "<cmd>CodeCompanionChat Add<cr>", { desc = "Add to AI Chat" })
  end,
}
