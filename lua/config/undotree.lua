local M = {}

local buf, win, target_buf, original_seq
local ns_id = vim.api.nvim_create_namespace("undotree_diff")

function M.toggle()
    if win and vim.api.nvim_win_is_valid(win) then
        M.close()
        return
    end

    target_buf = vim.api.nvim_get_current_buf()
    local ut_start = vim.fn.undotree()
    original_seq = ut_start.seq_cur

    buf = vim.api.nvim_create_buf(false, true)
    local width = 35
    local height = 15

    win = vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = width,
        height = height,
        col = vim.o.columns - width - 2,
        row = 2,
        style = "minimal",
        border = "rounded",
        title = " Undo History ",
    })

    M.refresh()
end

function M.close()
    if win and vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_win_close(win, true)
    end
    win = nil
    -- Clear all highlights when we close
    vim.api.nvim_buf_clear_namespace(target_buf, ns_id, 0, -1)
end

function M.refresh()
    local ut
    vim.api.nvim_buf_call(target_buf, function() ut = vim.fn.undotree() end)

    local lines, seq_map = {}, {}
    local function walk(entries, indent)
        for _, e in ipairs(entries) do
            local mark = e.seq == ut.seq_cur and "●" or "○"
            table.insert(lines, string.format("%s%s Change #%d", indent, mark, e.seq))
            table.insert(seq_map, e.seq)
            if e.alt then walk(e.alt, indent .. "  ") end
        end
    end

    walk(ut.entries, "")

    vim.api.nvim_buf_set_option(buf, "modifiable", true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.api.nvim_buf_set_option(buf, "modifiable", false)

    -- Keybinds
    local opts = { buffer = buf, noremap = true, silent = true }
    vim.keymap.set("n", "<CR>", function()
        local seq = seq_map[vim.fn.line(".")]
        if seq then
            vim.api.nvim_buf_call(target_buf, function() vim.cmd("undo " .. seq) end)
            M.close()
        end
    end, opts)
    vim.keymap.set("n", "q", M.close, opts)

    -- THE HIGHLIGHTING LOGIC
    vim.api.nvim_create_autocmd("CursorMoved", {
        buffer = buf,
        callback = function()
            local seq = seq_map[vim.fn.line(".")]
            if not seq then return end

            -- 1. Get current content
            local current_lines = vim.api.nvim_buf_get_lines(target_buf, 0, -1, false)

            -- 2. Briefly jump to the undo state and grab its content
            local target_lines
            vim.api.nvim_buf_call(target_buf, function()
                vim.cmd("silent! noautocmd undo " .. seq)
                target_lines = vim.api.nvim_buf_get_lines(target_buf, 0, -1, false)
                vim.cmd("silent! noautocmd undo " .. original_seq) -- Jump back
            end)

            -- 3. Compare them using the diff engine
            local diff = vim.diff(table.concat(current_lines, "\n"), table.concat(target_lines, "\n"), {
                result_type = "indices"
            })

            -- 4. Apply Highlights
            vim.api.nvim_buf_clear_namespace(target_buf, ns_id, 0, -1)
            for _, hunk in ipairs(diff) do
                local start_a, count_a, start_b, count_b = unpack(hunk)
                -- If count_a > 0, it means lines were changed or removed from your current view
                if count_a > 0 then
                    for i = 0, count_a - 1 do
                        vim.api.nvim_buf_add_highlight(target_buf, ns_id, "DiffDelete", start_a + i - 1, 0, -1)
                    end
                end
                -- If count_b > 0 and count_a == 0, it means the target has additions
                -- We'll highlight the line AFTER which the addition happens
                if count_b > 0 and count_a == 0 then
                    vim.api.nvim_buf_add_highlight(target_buf, ns_id, "DiffAdd", math.max(0, start_a - 1), 0, -1)
                end
            end
        end,
    })
end

return M
