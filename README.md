# Neovim Configuration

This is a personal Neovim setup designed to be a fast, modular, and powerful development environment. While it remains lightweight, it provides a comprehensive experience for high-level development, particularly for Python and Java, along with integrated local AI assistance.

## Primary Features

*   Plugin Management: Uses Lazy.nvim for efficient, asynchronous plugin handling.
*   Python Powerhouse: A complete Python environment featuring Basedpyright for precise type checking and Ruff for extremely fast linting and formatting. It includes integrated testing, virtual environment management, and Jupyter-style interactive execution.
*   Java Development: Full jdtls integration with automated formatting and specialized organization tools.
*   Local AI Integration: Built-in support for CodeCompanion and OpenCode, configured to use local models via Ollama to keep your code private and avoid subscription limits.
*   Debugging: Integrated debugging via DAP with custom UI layouts and color-coded consoles.
*   Aesthetics: Uses the Tokyo Night theme with a customized statusline and streamlined UI components for a focused workspace.

---

## Keybindings

### Python Development
This configuration turns Neovim into a full-scale Python IDE. All Python-specific tools are grouped under the leader-p prefix.

| Shortcut | Action | Description |
| :--- | :--- | :--- |
| <leader>pv | Select VirtualEnv | Choose from detected virtual environments |
| <leader>pt | Run Nearest Test | Execute the test under the cursor |
| <leader>pT | Run File Tests | Execute all tests in the current buffer |
| <leader>ps | Test Summary | Toggle the test results sidebar |
| <leader>pd | Generate Docstring | Create Google-style documentation |
| <leader>pr | Refactor Menu | Access refactoring options (Visual mode) |
| <leader>pi | Init Interactive | Start a Molten interactive session |
| <leader>pl | Evaluate Line | Send the current line to Molten |
| <leader>pe | Evaluate Range | Send selection to Molten |
| <leader>ph | Hide Output | Hide interactive execution results |

### AI Assistance
Integrated AI workflows using local models.

| Shortcut | Action | Provider |
| :--- | :--- | :--- |
| <leader>ac | Toggle AI Chat | CodeCompanion |
| <leader>aa | AI Actions Menu | CodeCompanion |
| ga (Visual) | Add to Chat | CodeCompanion |
| <leader>os | Start Agent Server | OpenCode |
| <leader>ot | Toggle Agent Window | OpenCode |
| <leader>oc | Agent Chat | OpenCode |
| <leader>oa | Agent Actions | OpenCode |

### Development & LSP
Standard language server features for all supported languages.

| Shortcut | Action |
| :--- | :--- |
| K | Show documentation hover |
| gd | Go to definition |
| gr | Find references |
| gi | Go to implementation |
| <F2> | Rename symbol |
| <F3> | Format buffer |
| <F4> | Show code actions |
| <leader>f | Manual format |
| <leader>r | Run current file |

### Window & Workspace
Tools for managing your editor layout and navigating files.

| Shortcut | Action |
| :--- | :--- |
| jj | Exit insert or terminal mode |
| <leader>e | Toggle file explorer (Neo-tree) |
| <leader>ff | Search for files |
| <leader>fg | Live search text (Grep) |
| <leader>fb | Switch between buffers |
| <leader>hh/jj/kk/ll | Navigate between window splits |
| <leader>z | Zoom / Maximize current window |
| <leader>m | Minimize current split |
| <leader>M | Restore last minimized split |

### Debugging
| Shortcut | Action |
| :--- | :--- |
| <leader>db | Toggle breakpoint |
| <leader>dc | Continue or start session |
| <leader>dt | Terminate debugging |
| <leader>du | Toggle debug user interface |

---

## Setup and Installation

1. Clone this repository into your `~/.config/nvim` directory.
2. Open Neovim; Lazy.nvim will automatically handle the installation of all plugins.
3. Mason will manage the installation of language servers and debuggers. It is configured to automatically pull Basedpyright, Ruff, and Debugpy.
4. For AI features, you will need Ollama installed with your preferred models (qwen2.5-coder is recommended) pulled and running locally.
5. For interactive Python features, ensure you have `pynvim` and `jupyter_client` installed in your global or base environment.
