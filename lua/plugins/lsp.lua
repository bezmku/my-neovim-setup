return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
        -- 1. Basic LSP settings (UI)
        vim.diagnostic.config({
            virtual_text = true,
            severity_sort = true,
            float = { border = "rounded" },
        })

        -- 2. LSP Keymaps & Formatting Logic
        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("UserLspConfig", {}),
            callback = function(args)
                local buf = args.buf
                local client = vim.lsp.get_client_by_id(args.data.client_id)
                local map = function(mode, lhs, rhs)
                    vim.keymap.set(mode, lhs, rhs, { buffer = buf })
                end

                -- Your existing navigation keymaps
                map("n", "K", vim.lsp.buf.hover)
                map("n", "gd", vim.lsp.buf.definition)
                map("n", "gr", vim.lsp.buf.references)
                map("n", "gD", vim.lsp.buf.declaration)
                map("n", "gi", vim.lsp.buf.implementation)
                map("n", "<F2>", vim.lsp.buf.rename)
                map("n", "<F3>", function() vim.lsp.buf.format({ async = true }) end)
                map("n", "<F4>", vim.lsp.buf.code_action)
                map("n", "gl", vim.diagnostic.open_float)

                -- ADD THIS: Auto-format on save
                -- This fixes messy indentation every time you write (:w)
                if client and client.supports_method("textDocument/formatting") then
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        buffer = buf,
                        callback = function()
                            vim.lsp.buf.format({ bufnr = buf, id = client.id })
                        end,
                    })
                end
            end,
        })

        -- 3. Enhanced capabilities for auto-imports and code actions
        local capabilities = require("cmp_nvim_lsp").default_capabilities()
        capabilities.textDocument.codeAction = {
            dynamicRegistration = true,
            codeActionLiteralSupport = {
                codeActionKind = {
                    valueSet = { "quickfix", "refactor", "source.organizeImports" }
                }
            }
        }

        -- 4. Server Configurations (Preserved your settings)
        
        -- Python
        vim.lsp.config["pyright"] = {
            capabilities = capabilities,
            settings = {
                python = {
                    analysis = {
                        typeCheckingMode = "basic",
                        autoSearchPaths = true,
                        useLibraryCodeForTypes = true,
                    },
                },
            },
        }

        -- C++
        vim.lsp.config["clangd"] = {
            cmd = { "clangd", "--background-index" },
            capabilities = capabilities,
        }

        -- JavaScript / React
        vim.lsp.config["ts_ls"] = {
            capabilities = capabilities,
        }

        -- CSS/HTML
        vim.lsp.config["cssls"] = { capabilities = capabilities }
        vim.lsp.config["html"] = { capabilities = capabilities }

        -- Lua
        vim.lsp.config["lua_ls"] = {
            capabilities = capabilities,
            settings = {
                Lua = {
                    diagnostics = { globals = { "vim" } },
                },
            },
        }

        -- 5. Enable all defined LSP servers
        for name, _ in pairs(vim.lsp.config._configs) do
            if name ~= "*" then
                vim.lsp.enable(name)
            end
        end
    end,
}
