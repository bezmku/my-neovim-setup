return {
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "nvim-neotest/nvim-nio",
            "mfussenegger/nvim-dap-python",
        },
        config = function()
            local dap = require("dap")
            local dapui = require("dapui")

            -- Setup DAP UI
            dapui.setup({
                icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
                mappings = {
                    expand = { "<CR>", "<2-LeftMouse>" },
                    open = "o",
                    remove = "d",
                    edit = "e",
                    repl = "r",
                    toggle = "t",
                },
                layouts = {
                    {
                        elements = {
                            { id = "scopes", size = 0.25 },
                            { id = "breakpoints", size = 0.25 },
                            { id = "stacks", size = 0.25 },
                            { id = "watches", size = 0.25 },
                        },
                        size = 40,
                        position = "left",
                    },
                    {
                        elements = {
                            { id = "repl", size = 0.5 },
                            { id = "console", size = 0.5 },
                        },
                        size = 10,
                        position = "bottom",
                    },
                },
                floating = {
                    max_height = nil,
                    max_width = nil,
                    border = "rounded",
                    mappings = {
                        close = { "q", "<Esc>" },
                    },
                },
            })

            -- Automatic UI toggle
            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()
            end

            -- Python configuration
            require("dap-python").setup("~/.local/share/nvim/mason/packages/debugpy/bin/python")

            -- Java configuration hook
            -- This will be triggered when nvim-jdtls attaches
            vim.api.nvim_create_autocmd("FileType", {
                pattern = "java",
                callback = function()
                    local jdtls_ok, jdtls = pcall(require, "jdtls")
                    if jdtls_ok then
                        jdtls.setup_dap({ hotcodereplace = "auto" })
                    end
                end,
            })

            -- Custom Colors for Debug Console
            -- We customize the highlight groups used by DAP-UI to make them "coolored"
            vim.api.nvim_set_hl(0, "DapUIPlayPause", { fg = "#98c379" })
            vim.api.nvim_set_hl(0, "DapUIRestart", { fg = "#a9a1e1" })
            vim.api.nvim_set_hl(0, "DapUIStop", { fg = "#e06c75" })
            vim.api.nvim_set_hl(0, "DapUIStepOver", { fg = "#61afef" })
            vim.api.nvim_set_hl(0, "DapUIStepInto", { fg = "#61afef" })
            vim.api.nvim_set_hl(0, "DapUIStepBack", { fg = "#61afef" })
            vim.api.nvim_set_hl(0, "DapUIStepOut", { fg = "#61afef" })
            
            -- Console colors (DAP-UI Console/REPL)
            vim.api.nvim_set_hl(0, "DapUIValue", { fg = "#98c379" }) -- Values/Output
            vim.api.nvim_set_hl(0, "DapUIVariable", { fg = "#e06c75" }) -- Variables
            vim.api.nvim_set_hl(0, "DapUIScope", { fg = "#61afef" }) -- Scopes
            vim.api.nvim_set_hl(0, "DapUIType", { fg = "#c678dd" }) -- Types
            vim.api.nvim_set_hl(0, "DapUIModifiedValue", { fg = "#d19a66", bold = true })
            
            -- Keymaps
            local map = vim.keymap.set
            map("n", "<leader>db", dap.toggle_breakpoint, { desc = "DAP: Toggle Breakpoint" })
            map("n", "<leader>dc", dap.continue, { desc = "DAP: Continue/Start" })
            map("n", "<leader>dt", dap.terminate, { desc = "DAP: Terminate" })
            map("n", "<leader>du", dapui.toggle, { desc = "DAP: Toggle UI" })
            map("n", "<leader>di", dap.step_into, { desc = "DAP: Step Into" })
            map("n", "<leader>do", dap.step_over, { desc = "DAP: Step Over" })
        end,
    },
}
