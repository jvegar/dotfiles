return {
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			local config = require("nvim-treesitter")
			config.setup({
				install_dir = vim.fn.stdpath("data") .. "/site",

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
			config.install({
				"bash",
				"c_sharp",
				"css",
				"diff",
				"dockerfile",
				"go",
				"html",
				"javascript",
				"json",
				"latex",
				"lua",
				"markdown",
				"markdown_inline",
				"prisma",
				"python",
				"rust",
				"typescript",
				"tsx",
				"vim",
				"yaml",
			})
		end,
	},
}
