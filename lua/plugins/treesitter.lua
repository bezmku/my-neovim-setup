return {
    'nvim-treesitter/nvim-treesitter',
    branch = "master",
    build = ":TSUpdate",
    config = function()
	local configs = require("nvim-treesitter.configs")
	configs.setup({
	    highlight = {
		enable = true,
	    },
	    indent = { enable = true },
	    autotag = { enable = true },
	    ensure_installed = {
		"lua",
		"python",
		"javascript",
		"cpp",
		"java",
		"vim",
		"c",
		"html",
		"css",
		"vimdoc",
		"sql",

	    },

	    auto_install = true,


	})
    end
    
   --plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}


}
