return {
    {
        "CRAG666/code_runner.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("code_runner").setup({
                filetype = {
                    java = "cd $dir && javac $fileName && java $fileNameWithoutExt",
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
