-- ─────────────────────────────────────────────────────────────────────────────
--  Theme Switcher
--  <leader>tt  → open theme picker (live preview, Esc to cancel)
-- ─────────────────────────────────────────────────────────────────────────────

local PERSIST_FILE = vim.fn.stdpath("config") .. "/.current_theme"

-- ── Catalogue ────────────────────────────────────────────────────────────────
local themes = {
    { name = "Tokyo Night Night",  colorscheme = "tokyonight-night",  lualine = "tokyonight" },
    { name = "Tokyo Night Storm",  colorscheme = "tokyonight-storm",  lualine = "tokyonight" },
    { name = "Tokyo Night Moon",   colorscheme = "tokyonight-moon",   lualine = "tokyonight" },
    { name = "Catppuccin Mocha",   colorscheme = "catppuccin-mocha",  lualine = "catppuccin" },
    { name = "Catppuccin Frappe",  colorscheme = "catppuccin-frappe", lualine = "catppuccin" },
    { name = "Catppuccin Latte",   colorscheme = "catppuccin-latte",  lualine = "catppuccin" },
    { name = "Rose Pine",          colorscheme = "rose-pine",         lualine = "rose-pine"  },
    { name = "Rose Pine Dawn",     colorscheme = "rose-pine-dawn",    lualine = "rose-pine"  },
    { name = "Gruvbox Dark",       colorscheme = "gruvbox",           lualine = "gruvbox"    },
    { name = "Kanagawa Wave",      colorscheme = "kanagawa-wave",     lualine = "kanagawa"   },
    { name = "Kanagawa Dragon",    colorscheme = "kanagawa-dragon",   lualine = "kanagawa"   },
    { name = "Kanagawa Lotus",     colorscheme = "kanagawa-lotus",    lualine = "kanagawa"   },
    { name = "Nightfox",           colorscheme = "nightfox",          lualine = "nightfox"   },
    { name = "Carbonfox",          colorscheme = "carbonfox",         lualine = "carbonfox"  },
    { name = "Everforest",         colorscheme = "everforest",        lualine = "everforest" },
    { name = "Cyberdream",         colorscheme = "cyberdream",        lualine = "cyberdream" },
    { name = "Nordic",             colorscheme = "nordic",            lualine = "nordic"     },
    { name = "Dracula",            colorscheme = "dracula",           lualine = "dracula"    },
    { name = "Mellow",             colorscheme = "mellow",            lualine = "mellow"     },
}

-- ── Persistence ───────────────────────────────────────────────────────────────
local function save_index(idx)
    local f = io.open(PERSIST_FILE, "w")
    if f then f:write(tostring(idx)); f:close() end
end

local function load_index()
    local f = io.open(PERSIST_FILE, "r")
    if f then
        local raw = f:read("*a"); f:close()
        local idx = tonumber(raw)
        if idx and idx >= 1 and idx <= #themes then return idx end
    end
    return 1
end

local current_index = load_index()

local function fix_highlights()
    -- Groups to make transparent
    local groups = {
        "Normal", "NormalNC", "SignColumn", "LineNr", "CursorLineNr",
        "EndOfBuffer", "MsgArea", "Pmenu", "NormalFloat", "FloatBorder",
        "TelescopeNormal", "TelescopeBorder", "TelescopePromptBorder",
        "NeoTreeNormal", "NeoTreeNormalNC", "NeoTreeWinSeparator"
    }
    for _, group in ipairs(groups) do
        vim.api.nvim_set_hl(0, group, { bg = "none" })
    end

    -- Subtle cursorline that works with transparency
    local bg_color = vim.o.background == "dark" and "#2c2e34" or "#e1e2e7"
    vim.api.nvim_set_hl(0, "CursorLine", { bg = bg_color })

    -- ── Syntax Pop ───────────────────────────────────────────────────────────
    -- Annotations (@Data, @Entity): Warm Yellow/Orange
    vim.api.nvim_set_hl(0, "@attribute", { fg = "#e0af68", bold = true })
    vim.api.nvim_set_hl(0, "@annotation", { fg = "#e0af68", bold = true })
    
    -- Methods: Vibrant Blue
    vim.api.nvim_set_hl(0, "@method", { fg = "#7aa2f7", bold = true })
    vim.api.nvim_set_hl(0, "@function.method", { fg = "#7aa2f7", bold = true })
    
    -- Variables & Fields: Soft Green
    vim.api.nvim_set_hl(0, "@variable", { fg = "#9ece6a" })
    vim.api.nvim_set_hl(0, "@variable.member", { fg = "#9ece6a" })
    
    -- Data Types (String, int, List): Bright Cyan
    vim.api.nvim_set_hl(0, "@type", { fg = "#0db9d7", bold = true })
    vim.api.nvim_set_hl(0, "@type.builtin", { fg = "#0db9d7", bold = true })
    
    -- Access Modifiers (public, private): Magenta/Purple
    vim.api.nvim_set_hl(0, "@keyword.modifier", { fg = "#bb9af7", italic = true })
    
    -- Structural Keywords: Bold White/Gray
    vim.api.nvim_set_hl(0, "@keyword", { fg = "#c0caf5", bold = true })
    
    -- Imports: Distinct warm color
    vim.api.nvim_set_hl(0, "@keyword.import", { fg = "#ff9e64", bold = true })
end

-- ── Apply ─────────────────────────────────────────────────────────────────────
local function apply_theme(idx, silent)
    local t = themes[idx]
    local ok, err = pcall(vim.cmd.colorscheme, t.colorscheme)
    if not ok then
        vim.notify("󰎑 Theme error: " .. err, vim.log.levels.WARN)
        return
    end
    fix_highlights()
    save_index(idx)
    if not silent then
        vim.notify("󰎑  " .. t.name, vim.log.levels.INFO)
    end
end

-- ── Telescope picker ──────────────────────────────────────────────────────────
local function open_theme_picker()
    local ok_tel, pickers      = pcall(require, "telescope.pickers")
    local ok_fin, finders      = pcall(require, "telescope.finders")
    local ok_cfg, conf         = pcall(require, "telescope.config")
    local ok_act, actions      = pcall(require, "telescope.actions")
    local ok_sta, action_state = pcall(require, "telescope.actions.state")

    if not (ok_tel and ok_fin and ok_cfg and ok_act and ok_sta) then
        vim.notify("Telescope is required for the theme picker", vim.log.levels.ERROR)
        return
    end

    local prev_index = current_index  -- remember so Esc can restore it

    local function preview_selection()
        local sel = action_state.get_selected_entry()
        if not sel then return end
        pcall(vim.cmd.colorscheme, sel.value.colorscheme)
        fix_highlights()
    end

    pickers.new({}, {
        prompt_title  = "󰎑  Choose Theme",
        results_title = string.format("  %d themes  |  <CR> apply  |  <Esc> cancel", #themes),
        layout_config = { width = 0.4, height = 0.6 },

        finder = finders.new_table({
            results = themes,
            entry_maker = function(entry)
                -- Find the index so we can jump to current theme at open
                local idx = 1
                for i, t in ipairs(themes) do
                    if t.colorscheme == entry.colorscheme then idx = i; break end
                end
                return {
                    value   = entry,
                    display = (idx == current_index and "  " or "   ") .. entry.name,
                    ordinal = entry.name,
                }
            end,
        }),

        sorter = conf.values.generic_sorter({}),

        attach_mappings = function(prompt_bufnr, map)
            -- preview_selection must run AFTER telescope updates its selection
            -- pointer, so we always defer with vim.schedule.
            local function preview_after_move()
                vim.schedule(function()
                    local sel = action_state.get_selected_entry()
                    if not sel then return end
                    pcall(vim.cmd.colorscheme, sel.value.colorscheme)
                    fix_highlights()
                end)
            end

            -- Override every key that moves the selection so we get live preview
            local function move_next()
                actions.move_selection_next(prompt_bufnr)
                preview_after_move()
            end
            local function move_prev()
                actions.move_selection_previous(prompt_bufnr)
                preview_after_move()
            end

            map("i", "<Down>",  move_next)
            map("i", "<Up>",    move_prev)
            map("i", "<C-n>",   move_next)
            map("i", "<C-p>",   move_prev)
            map("n", "j",       move_next)
            map("n", "k",       move_prev)
            map("n", "<Down>",  move_next)
            map("n", "<Up>",    move_prev)

            -- <CR> → confirm, apply fully and save
            actions.select_default:replace(function()
                local sel = action_state.get_selected_entry()
                actions.close(prompt_bufnr)
                if sel then
                    for i, t in ipairs(themes) do
                        if t.colorscheme == sel.value.colorscheme then
                            current_index = i
                            apply_theme(i)
                            return
                        end
                    end
                end
            end)

            -- <Esc> / q → cancel, restore previous theme
            local function cancel()
                actions.close(prompt_bufnr)
                apply_theme(prev_index, true)
            end
            map("i", "<Esc>", cancel)
            map("n", "<Esc>", cancel)
            map("n", "q",     cancel)

            return true
        end,
    }):find()
end

-- ── Keymap ────────────────────────────────────────────────────────────────────
vim.keymap.set("n", "<leader>tt", open_theme_picker, { desc = "Theme picker" })

-- ── Bootstrap ─────────────────────────────────────────────────────────────────
-- tokyonight is lazy=false so it is ALWAYS available at startup.
-- apply_theme() will load any other lazy theme plugin on demand via
-- lazy.nvim's colorscheme interception when the user picks something else.

-- ── Plugin specs ──────────────────────────────────────────────────────────────
return {
    {
        "folke/tokyonight.nvim",
        lazy     = false,   -- must be eager so it exists on first startup
        priority = 1000,    -- load before everything else
        config   = function()
            apply_theme(current_index, true)
        end,
    },
    { "catppuccin/nvim",          name = "catppuccin", lazy = true },
    { "rose-pine/neovim",         name = "rose-pine",  lazy = true },
    { "ellisonleao/gruvbox.nvim", lazy = true },
    { "rebelot/kanagawa.nvim",    lazy = true },
    { "EdenEast/nightfox.nvim",   lazy = true },
    { "sainnhe/everforest",       lazy = true },
    { "scottmckendry/cyberdream.nvim", lazy = true },
    { "AlexvZyl/nordic.nvim",     lazy = true },
    { "Mofiqul/dracula.nvim",     lazy = true },
    { "kvrohit/mellow.nvim",      lazy = true },
}
