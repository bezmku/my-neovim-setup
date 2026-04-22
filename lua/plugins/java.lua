return {
    "mfussenegger/nvim-jdtls",
    ft = "java",
    config = function()
        local home = os.getenv("HOME")
        local jdtls_path = home .. "/.local/share/nvim/mason/packages/jdtls/bin/jdtls"
        
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "java",
            callback = function()
                local jdtls = require("jdtls")
                local capabilities = require("cmp_nvim_lsp").default_capabilities()

                local root_markers = { ".git", "pom.xml", "mvnw", ".project", "inheritance" }
                local project_root = require("jdtls.setup").find_root(root_markers)

                if project_root and project_root ~= "" then
                    local src_root = project_root .. "/src"
                    
                    local project_name = vim.fn.fnamemodify(project_root, ":p:h:t")
                    local workspace_dir = home .. "/.local/share/eclipse/" .. project_name

                    local config = {
                        cmd = { jdtls_path, "-data", workspace_dir },

                        -- ✅ FIX: use project root here
                        root_dir = project_root,

                        capabilities = capabilities,

                        settings = {
                            java = {
                                signatureHelp = { enabled = true },
                                contentProvider = { preferred = 'fernflower' },
                                completion = {
                                    favoriteStaticMembers = {
                                        "org.junit.Assert.*",
                                        "org.junit.jupiter.api.Assertions.*",
                                    },
                                },
                                sources = {
                                    organizeImports = {
                                        starThreshold = 9999,
                                        staticStarThreshold = 9999,
                                    },
                                },
                            },
                        },

                        -- ✅ THIS tells jdtls where your source lives
                        init_options = {
                            workspaceFolders = {
                                vim.uri_from_fname(src_root)
                            }
                        },
                    }

                    jdtls.start_or_attach(config)
                    
                    print("Java LSP attached to Project Root: " .. project_root)
                else
                    print("LSP Warning: Could not find project root")
                end

                local opts = { buffer = true, silent = true }
                vim.keymap.set("n", "<leader>oi", jdtls.organize_imports, { desc = "Organize Imports", unpack(opts) })
                vim.keymap.set("n", "<leader>ev", jdtls.extract_variable, { desc = "Extract Variable", unpack(opts) })
                vim.keymap.set("n", "<leader>ec", jdtls.extract_constant, { desc = "Extract Constant", unpack(opts) })
            end,
        })
    end,
}
