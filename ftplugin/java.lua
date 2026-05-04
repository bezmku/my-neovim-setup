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

local root_markers = { "pom.xml", "build.gradle", ".git" }
local root_dir = require("jdtls.setup").find_root(root_markers)
if root_dir == "" or root_dir == nil then
    root_dir = vim.fn.getcwd()
end

local project_name = vim.fn.fnamemodify(root_dir, ":t")
local workspace_dir = home .. "/.local/share/eclipse/" .. project_name

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
    print("JDTLS CMD: " .. table.concat(cmd, " "))
    print("Root Dir: " .. root_dir)
    print("Workspace: " .. workspace_dir)
end, { desc = "Show JDTLS status" })

vim.api.nvim_buf_create_user_command(0, "JdtlsClean", function()
    vim.fn.system("rm -rf " .. vim.fn.shellescape(workspace_dir))
    vim.notify("Cleaned workspace: " .. workspace_dir .. ". Please restart Neovim.", vim.log.levels.WARN)
end, { desc = "Clean JDTLS workspace" })

-- Keymaps
local opts = { buffer = true, silent = true }
vim.keymap.set("n", "<leader>oi", jdtls.organize_imports, { desc = "Organize Imports", buffer = true })
