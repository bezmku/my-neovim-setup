return {
  'akinsho/flutter-tools.nvim',
  lazy = false,
  dependencies = {
    'nvim-lua/plenary.nvim',
    'stevearc/dressing.nvim', -- optional for better UI
  },
  config = function()
    require("flutter-tools").setup({
      ui = {
        -- the border type to use for all floating windows, the same options/formats
        -- as vim.api.nvim_open_win can be used.
        border = "rounded",
      },
      decorations = {
        statusline = {
          -- set to true to be able use the 'flutter_tools_decorations.statusline' [as a segment in lualine]
          app_version = true,
          device = true,
          project_config = true,
        }
      },
      debugger = {
        enabled = true,
        run_via_dap = true,
        register_configurations = function(_)
          require("dap").configurations.dart = {
            {
              type = "dart",
              request = "launch",
              name = "Launch flutter",
              dartSdkPath = "dart", -- will be found in PATH
              flutterSdkPath = "flutter", -- will be found in PATH
              program = "${file}",
              cwd = "${workspaceFolder}",
            }
          }
        end,
      },
      lsp = {
        color = { -- show the colors in editor
          enabled = true,
          background = false,
          foreground = false,
          virtual_text = true,
          virtual_text_str = "■",
        },
        settings = {
          showTodos = true,
          completeFunctionCalls = true,
          renameFilesWithClasses = "always", -- "always"
          enableSnippets = true,
          updateImportsOnRename = true,
        }
      }
    })

    -- Keybindings
    local map = function(lhs, rhs, desc)
      vim.keymap.set("n", lhs, rhs, { desc = desc })
    end

    map("<leader>fr", ":FlutterRun<CR>", "Flutter: Run")
    map("<leader>fq", ":FlutterQuit<CR>", "Flutter: Quit")
    map("<leader>fh", ":FlutterHotReload<CR>", "Flutter: Hot Reload")
    map("<leader>fR", ":FlutterHotRestart<CR>", "Flutter: Hot Restart")
    map("<leader>fd", ":FlutterDevices<CR>", "Flutter: Devices")
    map("<leader>fem", ":FlutterEmulators<CR>", "Flutter: Emulators")
  end,
}
