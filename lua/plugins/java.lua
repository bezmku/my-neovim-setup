return {
    {
        "mfussenegger/nvim-jdtls",
        ft = "java",
        dependencies = {
            "JavaHello/spring-boot.nvim",
        },
        config = function()
            -- Configuration is now handled in ftplugin/java.lua
        end,
    },
}
