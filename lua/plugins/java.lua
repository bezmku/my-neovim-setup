return {
    {
        "mfussenegger/nvim-jdtls",
        ft = "java",
        dependencies = {
            "JavaHello/spring-boot.nvim",
        },
        config = function()
            local home = os.getenv("HOME")
            local jdtls_path = home .. "/.local/share/nvim/mason/packages/jdtls/bin/jdtls"
            local lombok_jar = home .. "/.local/share/nvim/mason/packages/jdtls/lombok.jar"

            vim.api.nvim_create_autocmd("FileType", {
                pattern = "java",
                callback = function()
                    local jdtls = require("jdtls")
                    
                    local root_markers = { "pom.xml", "build.gradle", ".git" }
                    local root_dir = require("jdtls.setup").find_root(root_markers)
                    if root_dir == "" or root_dir == nil then
                        root_dir = vim.fn.getcwd()
                    end

                    local project_name = vim.fn.fnamemodify(root_dir, ":t")
                    local workspace_dir = home .. "/.local/share/eclipse/" .. project_name

                    local config = {
                        cmd = {
                            jdtls_path,
                            "-data", workspace_dir,
                            "--jvm-arg=-javaagent:" .. lombok_jar,
                        },
                        root_dir = root_dir,
                        settings = {
                            java = {
                                signatureHelp = { enabled = true },
                                contentProvider = { preferred = "fernflower" },
                                jdt = {
                                    ls = {
                                        lombokSupport = {
                                            enabled = true,
                                        },
                                    },
                                },
                            },
                        },
                    }

                    jdtls.start_or_attach(config)

                    -- Basic keymaps
                    local opts = { buffer = true, silent = true }
                    vim.keymap.set("n", "<leader>oi", jdtls.organize_imports, { desc = "Organize Imports", buffer = true })
                    
                    -- Clean workspace command
                    vim.api.nvim_buf_create_user_command(0, "JdtlsClean", function()
                        vim.fn.system("rm -rf " .. vim.fn.shellescape(workspace_dir))
                        vim.notify("Cleaned workspace: " .. workspace_dir .. ". Restart Neovim.", vim.log.levels.WARN)
                    end, { desc = "Clean jdtls workspace" })
                end,
            })
        end,
    },
}
