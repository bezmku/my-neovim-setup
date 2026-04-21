return {
  "supermaven-inc/supermaven-nvim",
  config = function()
    require("supermaven-nvim").setup({
      keymaps = {
        accept_suggestion = "<Tab>",
        clear_suggestion = "<C-]>",
        accept_word = "<C-j>",
      },
      ignore_filetypes = { "cpp" }, -- You can customize this
      color = {
        suggestion_color = "#ffffff",
        cterm = 244,
      }
    })
  end,
}
