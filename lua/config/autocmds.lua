-- Automatically add Java package declaration to new files
vim.api.nvim_create_autocmd("BufNewFile", {
  pattern = "*.java",
  callback = function()
    local filepath = vim.fn.expand("%:p:h") -- Get absolute path to the directory
    local root_pattern = "src" -- We look for 'src' as the root
    
    -- Find where 'src' is in the path
    local _, src_index = filepath:find(root_pattern)
    
    if src_index then
      -- Cut everything before and including 'src/'
      local package_path = filepath:sub(src_index + 2) 
      
      -- Convert folder slashes '/' into dots '.'
      local package_name = package_path:gsub("/", ".")
      
      -- If the path isn't empty, insert the package line
      if package_name ~= "" then
        local line = "package " .. package_name .. ";"
        vim.api.nvim_buf_set_lines(0, 0, 0, false, { line, "" })
        
        -- Move cursor to the end of the file so you can start typing
        vim.api.nvim_win_set_cursor(0, {3, 0})
      end
    end
  end,
})
