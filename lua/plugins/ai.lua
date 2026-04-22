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
          adapter = "groq",
        },
        inline = {
          adapter = "groq",
        },
      },
      adapters = {
        -- We define the adapter here to ensure Neovim "finds" it
        groq = function()
          return require("codecompanion.adapters").extend("groq", {
            env = {
              -- USE YOUR GROQ KEY HERE
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
  end,
}
