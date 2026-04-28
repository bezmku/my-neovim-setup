return {
    {
        "CRAG666/code_runner.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("code_runner").setup({
                mode = "float",
                float = {
                    close_key = "<ESC>",
                    border = "rounded",
                    border_hl = "FloatBorder",
                    float_hl = "Normal",
                    blend = 10,
                },
                filetype = {
                    java = "echo -e '\\033[1;34m[System]\\033[0m Compiling and Running Java...' && root=$(git rev-parse --show-toplevel 2>/dev/null || pwd) && cd $root && javac -d . -sourcepath src $file && java $(echo $file | sed \"s|$root/src/||\" | sed \"s|\\.java$||\" | tr '/' '.')",
                    python = "echo -e '\\033[1;34m[System]\\033[0m Running Python...' && python3 $file",
                    cpp = "echo -e '\\033[1;34m[System]\\033[0m Compiling and Running C++...' && cd $dir && g++ $fileName -o $fileNameWithoutExt && ./$fileNameWithoutExt",
                    javascript = "echo -e '\\033[1;34m[System]\\033[0m Running JavaScript...' && node $file",
                    typescript = "echo -e '\\033[1;34m[System]\\033[0m Running TypeScript...' && ts-node $file",
                    html = "open $file",  -- Opens in browser
                    css = "echo -e '\\033[1;31m[System]\\033[0m CSS cannot be run directly'",
                },
            })
            -- Keymap to run code: <leader>r
            vim.keymap.set("n", "<leader>r", ":RunCode<CR>", { desc = "Run code" })
        end,
    },
}
