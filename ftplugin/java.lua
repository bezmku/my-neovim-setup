local home = vim.fn.expand("~")
local mason_path = home .. "/.local/share/nvim/mason/packages"
local jdtls_dir = mason_path .. "/jdtls"

-- Find the launcher jar
local launcher_jar = vim.fn.glob(jdtls_dir .. "/plugins/org.eclipse.equinox.launcher_*.jar")
if launcher_jar == "" then
    return
end

launcher_jar = vim.fn.split(launcher_jar, "\n")[1]

local lombok_jar = jdtls_dir .. "/lombok.jar"
local config_dir = jdtls_dir .. "/config_linux"

local jdtls_ok, jdtls = pcall(require, "jdtls")
if not jdtls_ok then
    return
end

local function get_root()
    -- 1. Official markers
    local root = require("jdtls.setup").find_root({ "pom.xml", "build.gradle", "mvnw", "gradlew" })
    if root and root ~= "" then return root end
    
    -- 2. Nearest 'src' parent (for unmanaged)
    local filepath = vim.api.nvim_buf_get_name(0)
    local s, _ = filepath:find("/src/", 1, true)
    if s then
        return filepath:sub(1, s) 
    end
    
    -- 3. Only use .git if it's not a common parent like home or desktop
    local root_git = require("jdtls.setup").find_root({ ".git", ".project" })
    if root_git and root_git ~= home and root_git ~= home .. "/Desktop" then
        return root_git
    end
    
    return vim.fn.expand("%:p:h")
end

local root_dir = get_root()

-- Use a unique hash for the workspace based on the absolute path to prevent bleeding
local workspace_id = vim.fn.sha256(root_dir):sub(1, 10)
local project_name = vim.fn.fnamemodify(root_dir, ":t")
local workspace_dir = home .. "/.local/share/eclipse/" .. project_name .. "_" .. workspace_id

-- Automatic Project Initialization (Silent)
local function silent_init(root)
    if not root or root == "" then return end
    local classpath = root .. "/.classpath"
    local project = root .. "/.project"
    local is_managed_check = vim.fn.filereadable(root .. "/pom.xml") == 1 or 
                             vim.fn.filereadable(root .. "/build.gradle") == 1

    -- Use a unique name to prevent JDTLS metadata collisions
    local proj_unique_name = project_name .. "_" .. workspace_id

    -- If it has a src folder but no markers (or old markers), create them
    if not is_managed_check and vim.fn.isdirectory(root .. "/src") == 1 then
        local cp_content = [[<?xml version="1.0" encoding="UTF-8"?>
<classpath>
	<classpathentry kind="src" path="src"/>
	<classpathentry kind="con" path="org.eclipse.jdt.launching.JRE_CONTAINER"/>
	<classpathentry kind="output" path="bin"/>
</classpath>]]
        
        local proj_content = string.format([[<?xml version="1.0" encoding="UTF-8"?>
<projectDescription>
	<name>%s</name>
	<comment></comment>
	<projects></projects>
	<buildSpec>
		<buildCommand>
			<name>org.eclipse.jdt.core.javabuilder</name>
			<arguments></arguments>
		</buildCommand>
	</buildSpec>
	<natures>
		<nature>org.eclipse.jdt.core.javanature</nature>
	</natures>
</projectDescription>]], proj_unique_name)

        -- Overwrite to ensure unique naming is applied
        local f_cp = io.open(classpath, "w")
        if f_cp then f_cp:write(cp_content); f_cp:close() end
        local f_pj = io.open(project, "w")
        if f_pj then f_pj:write(proj_content); f_pj:close() end
    end
end

-- Run auto-init
silent_init(root_dir)

local is_managed = vim.fn.filereadable(root_dir .. "/pom.xml") == 1 or 
                   vim.fn.filereadable(root_dir .. "/build.gradle") == 1 or
                   vim.fn.filereadable(root_dir .. "/.project") == 1 or
                   vim.fn.filereadable(root_dir .. "/.classpath") == 1

local cmd = {
    "java",
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
    "-Xmx1g",
    "-javaagent:" .. lombok_jar,
    "--add-modules=ALL-SYSTEM",
    "--add-opens", "java.base/java.util=ALL-UNNAMED",
    "--add-opens", "java.base/java.lang=ALL-UNNAMED",
    "-jar", launcher_jar,
    "-configuration", config_dir,
    "-data", workspace_dir,
}

local config = {
    cmd = cmd,
    root_dir = root_dir, 
    settings = {
        java = {
            signatureHelp = { enabled = true },
            contentProvider = { preferred = "fernflower" },
            completion = {
                favoriteStaticMembers = {
                    "org.hamcrest.MatcherAssert.assertThat",
                    "org.hamcrest.Matchers.*",
                    "org.hamcrest.CoreMatchers.*",
                    "org.junit.jupiter.api.Assertions.*",
                    "java.util.Objects.requireNonNull",
                    "java.util.Objects.requireNonNullElse",
                    "org.mockito.Mockito.*",
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
        bundles = {},
    },
}

-- Start or attach
jdtls.start_or_attach(config)

-- Commands
vim.api.nvim_buf_create_user_command(0, "JdtlsStatus", function()
    print("Project Root: " .. (root_dir or "N/A"))
    print("Workspace:    " .. (workspace_dir or "N/A"))
    print("Is Managed:   " .. tostring(is_managed))
end, { desc = "Show JDTLS status" })

vim.api.nvim_buf_create_user_command(0, "JdtlsClean", function()
    vim.fn.system("rm -rf " .. vim.fn.shellescape(workspace_dir))
    vim.notify("Cleaned workspace. Please restart Neovim.", vim.log.levels.WARN)
end, { desc = "Clean JDTLS workspace" })

-- Maven Dependency Resolve
vim.api.nvim_buf_create_user_command(0, "MvnResolve", function()
    local pom = root_dir .. "/pom.xml"
    if vim.fn.filereadable(pom) == 0 then
        vim.notify("No pom.xml found", vim.log.levels.ERROR)
        return
    end

    vim.notify("Maven: Resolving dependencies...", vim.log.levels.INFO)
    vim.fn.jobstart("mvn dependency:resolve", {
        cwd = root_dir,
        on_exit = function(_, code)
            if code == 0 then
                vim.notify("Maven: Success!", vim.log.levels.INFO)
            else
                vim.notify("Maven: Failed!", vim.log.levels.ERROR)
            end
        end,
    })
end, { desc = "Download Maven dependencies" })

-- JavaInit now just calls silent_init explicitly if needed
vim.api.nvim_buf_create_user_command(0, "JavaInit", function() silent_init(root_dir) end, { desc = "Initialize project" })

-- Keymaps
local opts = { buffer = true, silent = true }
vim.keymap.set("n", "<leader>oi", jdtls.organize_imports, { desc = "Organize Imports", buffer = true })
vim.keymap.set("n", "<leader>md", ":MvnResolve<CR>", { desc = "Maven Download Dependencies", buffer = true })
