return {
    "williamboman/mason.nvim",
    dependencies = {
        "williamboman/mason-lspconfig.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    build = ":MasonUpdate",
    config = function()
        -- Ensure Mason knows where to find its tools during installation
        local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
        vim.env.PATH = mason_bin .. ":" .. vim.env.PATH

        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = {
                "pyright",
                "lua_ls",
            },
        })
        require("mason-tool-installer").setup({
            ensure_installed = {
                "debugpy",
                "black", -- Backup formatter if needed
                "ruff",
            },
        })
        require("mason-tool-installer").setup({
            ensure_installed = {
                "debugpy",
            },
        })
    end,
}
