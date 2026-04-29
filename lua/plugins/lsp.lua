return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
        -- Ensure Mason and Snap binaries are in the path
        local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
        vim.env.PATH = mason_bin .. ":/snap/bin:" .. vim.env.PATH

        -- 1. UI Customization
        vim.diagnostic.config({
            virtual_text = true,
            severity_sort = true,
            float = { border = "rounded" },
        })

        -- 2. LSP Keymaps & Formatting
        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("UserLspConfig", {}),
            callback = function(args)
                local buf = args.buf
                local client = vim.lsp.get_client_by_id(args.data.client_id)
                
                local map = function(mode, lhs, rhs, desc)
                    vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = desc })
                end

                map("n", "K", vim.lsp.buf.hover, "LSP: Hover")
                map("n", "gd", vim.lsp.buf.definition, "LSP: Go to Definition")
                map("n", "gr", vim.lsp.buf.references, "LSP: Find References")
                map("n", "gD", vim.lsp.buf.declaration, "LSP: Go to Declaration")
                map("n", "gi", vim.lsp.buf.implementation, "LSP: Go to Implementation")
                
                vim.keymap.set("n", "<F2>", function()
                    return ":IncRename " .. vim.fn.expand("<cword>")
                end, { expr = true, buffer = buf, desc = "LSP: Rename (Live)" })
                
                map("n", "<F3>", function() vim.lsp.buf.format({ async = true }) end, "LSP: Format")
                map("n", "<F4>", vim.lsp.buf.code_action, "LSP: Code Action")
                map("n", "gl", vim.diagnostic.open_float, "LSP: Diagnostics")

                -- Auto-format on save
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

        -- 3. The New Modern API (v0.12+)
        local capabilities = require("cmp_nvim_lsp").default_capabilities()
        local util = require("lspconfig.util")
        local root_pattern = util.root_pattern(".git", "pyproject.toml", "setup.py", "requirements.txt")

        -- Python
        vim.lsp.config["basedpyright"] = {
            cmd = { vim.fn.stdpath("data") .. "/mason/bin/basedpyright-langserver", "--stdio" },
            root_dir = function(fname)
                return root_pattern(fname) or util.path.dirname(fname)
            end,
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

        vim.lsp.config["ruff"] = {
            cmd = { vim.fn.stdpath("data") .. "/mason/bin/ruff", "server" },
            root_dir = function(fname)
                return root_pattern(fname) or util.path.dirname(fname)
            end,
            capabilities = capabilities,
            on_attach = function(client, _)
                client.server_capabilities.hoverProvider = false
            end,
        }

        -- Lua
        vim.lsp.config["lua_ls"] = { capabilities = capabilities }
        -- C++
        vim.lsp.config["clangd"] = { capabilities = capabilities }
        -- JS/TS
        vim.lsp.config["ts_ls"] = { capabilities = capabilities }

        -- 4. Explicitly Enable Servers
        vim.lsp.enable("basedpyright")
        vim.lsp.enable("ruff")
        vim.lsp.enable("lua_ls")
        vim.lsp.enable("clangd")
        vim.lsp.enable("ts_ls")
    end,
}
