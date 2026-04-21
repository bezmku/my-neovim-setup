-- Package manager for LSP servers, linters, and formatters
return {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",  -- Updates registry on install
    config = function()
        require("mason").setup()
    end,
}
