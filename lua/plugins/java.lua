return {
    "mfussenegger/nvim-jdtls",
    ft = "java",
    config = function()
        local home = os.getenv("HOME")
        local jdtls_path = home .. "/.local/share/nvim/mason/packages/jdtls/bin/jdtls"
        
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "java",
            callback = function()
                local jdtls = require("jdtls")
                
                -- FORCE jdtls to use vim.ui.select (Telescope) for its menus
                -- This makes the "Choose type to import" menu navigable.
                require('jdtls.ui').pick_one_async = function(items, prompt, label_fn, cb)
                    vim.ui.select(items, {
                        prompt = prompt,
                        format_item = label_fn,
                    }, cb)
                end

                local capabilities = require("cmp_nvim_lsp").default_capabilities()

                -- Multi-layered root detection
                local function find_project_root()
                    local bufname = vim.api.nvim_buf_get_name(0)
                    if bufname == "" then return nil end
                    local abs_path = vim.fn.fnamemodify(bufname, ":p")
                    
                    -- 1. Check for strong project markers (pom.xml, .git, etc.)
                    local project_markers = { "pom.xml", "build.gradle", ".project", ".git" }
                    local project_file = vim.fs.find(project_markers, { upward = true, path = abs_path })[1]
                    if project_file then
                        return vim.fs.dirname(project_file)
                    end
                    
                    -- 2. Look for the 'src' folder (Standard Java structure)
                    -- We return the parent of 'src'
                    local src_file = vim.fs.find("src", { upward = true, path = abs_path })[1]
                    if src_file then
                        return vim.fs.dirname(src_file)
                    end
                    
                    -- 3. Look for common package prefixes (com, org, net, etc.)
                    -- We return the parent of the package start
                    local pkg_markers = { "com", "org", "net", "edu", "gov" }
                    local pkg_file = vim.fs.find(pkg_markers, { upward = true, path = abs_path })[1]
                    if pkg_file then
                        return vim.fs.dirname(pkg_file)
                    end
                    
                    -- 4. Fallback to CWD if it contains the file, otherwise file dir
                    local cwd = vim.fn.getcwd()
                    if abs_path:find(cwd, 1, true) then
                        return cwd
                    end
                    return vim.fs.dirname(abs_path)
                end

                local project_root = find_project_root()

                if project_root and project_root ~= "" then
                    -- Detect source layout BEFORE building config so all blocks can use it
                    local has_src = vim.fn.isdirectory(project_root .. "/src") == 1

                    -- AUTO-INITIALIZE PROJECT METADATA
                    local dot_project = project_root .. "/.project"
                    local dot_classpath = project_root .. "/.classpath"
                    
                    if vim.fn.filereadable(dot_project) == 0 and vim.fn.isdirectory(project_root) == 1 then
                        local project_name = vim.fn.fnamemodify(project_root, ":p:h:t")
                        local src_path = has_src and "src" or ""
                        
                        -- Generate .project
                        local project_xml = [[<?xml version="1.0" encoding="UTF-8"?>
<projectDescription>
	<name>]] .. project_name .. [[</name>
	<buildSpec><buildCommand><name>org.eclipse.jdt.core.javabuilder</name></buildCommand></buildSpec>
	<natures><nature>org.eclipse.jdt.core.javanature</nature></natures>
</projectDescription>]]
                        local f = io.open(dot_project, "w")
                        if f then f:write(project_xml); f:close() end

                        -- Generate .classpath
                        local classpath_xml = [[<?xml version="1.0" encoding="UTF-8"?>
<classpath>
	<classpathentry kind="src" path="]] .. src_path .. [["/>
	<classpathentry kind="con" path="org.eclipse.jdt.launching.JRE_CONTAINER"/>
	<classpathentry kind="output" path="bin"/>
</classpath>]]
                        f = io.open(dot_classpath, "w")
                        if f then f:write(classpath_xml); f:close() end
                    end

                    local project_name = vim.fn.fnamemodify(project_root, ":p:h:t")
                    local path_hash = vim.fn.sha256(project_root):sub(1, 8)
                    local workspace_dir = home .. "/.local/share/eclipse/" .. project_name .. "_" .. path_hash

                    local config = {
                        cmd = { jdtls_path, "-data", workspace_dir },
                        root_dir = project_root,
                        capabilities = capabilities,
                        settings = {
                            java = {
                                signatureHelp = { enabled = true },
                                contentProvider = { preferred = 'fernflower' },
                                -- Tell jdtls WHERE source files live so that "move to package"
                                -- code actions (F4) place files under src/ instead of the
                                -- project root, preventing stray com/ directories.
                                project = {
                                    sourcePaths = has_src and { "src" } or { "." },
                                },
                                completion = {
                                    favoriteStaticMembers = {
                                        "org.junit.Assert.*",
                                        "org.junit.jupiter.api.Assertions.*",
                                    },
                                },
                                sources = {
                                    organizeImports = {
                                        starThreshold = 9999,
                                        staticStarThreshold = 9999,
                                    },
                                },
                            },
                        },
                        init_options = {
                            workspaceFolders = {
                                vim.uri_from_fname(project_root)
                            }
                        },
                    }

                    jdtls.start_or_attach(config)
                    print("Java LSP attached to: " .. project_root)
                end

                local opts = { buffer = true, silent = true }
                vim.keymap.set("n", "<leader>oi", require('jdtls').organize_imports, { desc = "Organize Imports", buffer = true })
                vim.keymap.set("n", "<leader>ev", jdtls.extract_variable, { desc = "Extract Variable", unpack(opts) })
                vim.keymap.set("n", "<leader>ec", jdtls.extract_constant, { desc = "Extract Constant", unpack(opts) })
            end,
        })
    end,
}
