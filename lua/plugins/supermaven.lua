return {
  "supermaven-inc/supermaven-nvim",
  config = function()
    require("supermaven-nvim").setup({
      keymaps = {
        accept_suggestion = "<M-CR>", -- Alt + Enter to accept AI suggestions
        clear_suggestion = "<C-]>",
        accept_word = "<C-j>",
      },
      ignore_filetypes = { "cpp" },
      color = {
        suggestion_color = "#ffffff",
        cterm = 244,
      }
    })
  end,
}
