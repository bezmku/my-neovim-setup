return {
    {
        "CRAG666/code_runner.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("code_runner").setup({
                filetype = {
                    java = "root=$(git rev-parse --show-toplevel 2>/dev/null || pwd) && cd $root && javac -d . -sourcepath src $file && java $(echo $file | sed \"s|$root/src/||\" | sed \"s|\\.java$||\" | tr '/' '.')",
                    python = "python3 $file",
                    cpp = "cd $dir && g++ $fileName -o $fileNameWithoutExt && ./$fileNameWithoutExt",
                    javascript = "node $file",
                    typescript = "ts-node $file",
                    html = "open $file",  -- Opens in browser
                    css = "echo 'CSS cannot be run directly'",
                },
            })
            -- Keymap to run code: <leader>r
            vim.keymap.set("n", "<leader>r", ":RunCode<CR>", { desc = "Run code" })
        end,
    },
}
