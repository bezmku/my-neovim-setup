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

                -- 1. Try to find a project root (git, maven, etc.)
                local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }
                local root_dir = require("jdtls.setup").find_root(root_markers)

                -- 2. THE FIX: If no markers exist, use the folder the file is in as the project root
                if root_dir == "" or root_dir == nil then
                    root_dir = vim.fn.expand("%:p:h")
                end

                -- 3. Create a unique workspace for this project
                -- This prevents different projects from overlapping and causing errors
                local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
                local workspace_dir = home .. "/.local/share/eclipse/" .. project_name

                jdtls.start_or_attach({
                    cmd = { jdtls_path, "-data", workspace_dir },
                    root_dir = root_dir,
                    capabilities = capabilities,
                    settings = {
                        java = {
                            signatureHelp = { enabled = true },
                            completion = { favoriteStaticMembers = { "org.junit.Assert.*" } },
                            contentProvider = { preferred = 'fernflower' },
                            sources = {
                                organizeImports = {
                                    starThreshold = 9999,
                                    staticStarThreshold = 9999,
                                },
                            },
                        }
                    },
                })
                
                -- Keymap for Java Imports
                vim.keymap.set("n", "<leader>oi", function()
                    require('jdtls').organize_imports()
                end, { buffer = true, desc = "Organize Java imports" })
            end,
        })
    end,
}
