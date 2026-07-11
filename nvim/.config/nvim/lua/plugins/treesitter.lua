return {
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.config").setup({
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
		end,
	},
}
