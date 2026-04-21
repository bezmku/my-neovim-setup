return {
    'nvim-treesitter/nvim-treesitter',
    build = ":TSUpdate",
    config = function()
	local config = require("nvim-treesitter.config")
	config.setup({
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
		"vimcode",
		"sql",

	    },

	    auto_install = true,


	})
    end
    
   --plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}


}
