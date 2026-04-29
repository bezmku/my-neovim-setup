# Neovim Configuration

This is a modular and efficient Neovim setup tailored for a streamlined development workflow. It focuses on deep LSP integration (specifically for Java), local AI assistance, and a clean, focused user interface.

## Core Features
*   **Plugin Management**: Handled by Lazy.nvim for fast, asynchronous loading.
*   **AI Integration**: Integrated with CodeCompanion and OpenCode, configured to run local models via Ollama.
*   **LSP & Development**: Full support for Java (jdtls), automated formatting, and integrated debugging (DAP).
*   **User Interface**: Minimalist aesthetic using Tokyo Night, with a clean statusline and searchable menus via Telescope.

---

## Custom Keybindings

### AI Assistance
| Shortcut | Action | Provider |
| :--- | :--- | :--- |
| <leader>ac | Toggle AI Chat | CodeCompanion |
| <leader>aa | AI Actions Menu | CodeCompanion |
| ga (Visual) | Add selection to Chat | CodeCompanion |
| <leader>os | Start Agent Server | OpenCode |
| <leader>ot | Toggle Agent Window | OpenCode |
| <leader>oq | Stop Agent Server | OpenCode |
| <leader>oc | Agent Chat (Ask) | OpenCode |
| <leader>oa | Agent Actions | OpenCode |

### Navigation & Workspace
| Shortcut | Action |
| :--- | :--- |
| jj | Exit Insert/Terminal mode |
| <leader>cd | Open File Explorer |
| <leader>e | Toggle Neo-tree |
| <leader>ff | Find Files |
| <leader>fg | Live Grep |
| <leader>fb | List Buffers |
| <leader>tt | Theme Picker |
| <leader>as | Toggle Auto-Save |

### Window Management
| Shortcut | Action |
| :--- | :--- |
| <leader>hh/jj/kk/ll | Move between splits |
| <leader>z | Toggle Window Zoom |
| <leader>m | Minimize split |
| <leader>M | Restore split |
| <leader><Arrows> | Resize windows |

### Development & LSP
| Shortcut | Action |
| :--- | :--- |
| K | Hover Documentation |
| gd | Go to Definition |
| gr | Go to References |
| gi | Go to Implementation |
| <F2> | Rename Symbol |
| <F3> | Format Buffer |
| <F4> | Code Actions |
| <leader>f | Manual Format |
| <leader>r | Run Current File |
| <leader>oi | Organize Imports (Java) |

### Version Control
| Shortcut | Action |
| :--- | :--- |
| <leader>gp | Preview Git Hunk |
| <leader>gb | Blame Line |
| <leader>gd | Git Diff |
| ]c / [c | Next/Prev Hunk |

### Debugging
| Shortcut | Action |
| :--- | :--- |
| <leader>db | Toggle Breakpoint |
| <leader>dc | Continue/Start |
| <leader>dt | Terminate Session |
| <leader>du | Toggle Debug UI |

---

## Installation
1. Clone this repository into `~/.config/nvim`.
2. Launch Neovim to trigger automatic plugin installation.
3. For AI features, ensure Ollama is installed and the required models (e.g., qwen2.5-coder) are pulled.
