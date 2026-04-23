vim.api.nvim_create_autocmd("BufNewFile", {
  pattern = "*.java",
  callback = function()
    local filepath = vim.fn.expand("%:p:h")

    -- match '/src/' specifically
    local src_start, src_end = filepath:find("/src/")

    if src_end then
      -- get everything AFTER '/src/'
      local package_path = filepath:sub(src_end + 1)

      -- convert / to .
      local package_name = package_path:gsub("/", ".")

      if package_name ~= "" then
        local line = "package " .. package_name .. ";"
        vim.api.nvim_buf_set_lines(0, 0, 0, false, { line, "" })
        vim.api.nvim_win_set_cursor(0, {3, 0})
      end
    end
  end,
})
