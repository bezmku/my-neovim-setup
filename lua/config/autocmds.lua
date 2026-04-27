vim.api.nvim_create_autocmd({"BufNewFile", "BufReadPost"}, {
  pattern = "*.java",
  callback = function(args)
    -- If it's an existing file, check if it's empty
    if args.event == "BufReadPost" then
      local size = vim.fn.getfsize(args.match)
      if size > 0 then
        return
      end
    end

    local buf_name = args.match
    if buf_name == "" then
      return
    end

    -- Check if buffer is already populated
    local lines_in_buf = vim.api.nvim_buf_get_lines(args.buf, 0, -1, false)
    if #lines_in_buf > 1 or (#lines_in_buf == 1 and lines_in_buf[1] ~= "") then
        return
    end

    local filepath = vim.fn.fnamemodify(buf_name, ":p:h")
    local filename = vim.fn.fnamemodify(buf_name, ":t:r")
    
    local lines = {}
    
    -- 1. Generate Package Declaration
    local src_start, src_end = filepath:find("/src/")
    if src_end then
      local package_path = filepath:sub(src_end + 1)
      local package_name = package_path:gsub("/", ".")
      if package_name ~= "" then
        table.insert(lines, "package " .. package_name .. ";")
        table.insert(lines, "")
      end
    end
    
    -- 2. Generate Class Skeleton
    table.insert(lines, "public class " .. filename .. " {")
    table.insert(lines, "    ")
    table.insert(lines, "}")
    
    -- 3. Apply to buffer and position cursor
    vim.api.nvim_buf_set_lines(args.buf, 0, -1, false, lines)
    local cursor_line = #lines - 1
    
    if vim.api.nvim_get_current_buf() == args.buf then
        vim.api.nvim_win_set_cursor(0, {cursor_line, 4})
    end
  end,
})
