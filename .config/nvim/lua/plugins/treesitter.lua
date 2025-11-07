return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			local config = require("nvim-treesitter.configs")
			config.setup({
				ignore_install = {},
				-- Enable automatic installation of language parsers
				auto_install = true,
				sync_install = false,

				-- Specify which parsers to ensure are installed
				ensure_installed = {
					"bash",
					"c_sharp",
					"css",
					"diff",
					"dockerfile",
					"go",
					"html",
					"javascript",
					"json",
					"lua",
					"markdown",
					"python",
					"rust",
					"typescript",
					"vim",
					"yaml",
				},

				-- Enable syntax highlighting using Treesitter
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = false,
				},

				-- Enable indentation based on Treesitter parsing
				indent = {
					enable = true,
					disable = { "python" }, -- Disable for Python due to known issues
				},
			})
		end,
	},
}
