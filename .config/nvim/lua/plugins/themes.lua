return {
	{
		"daschw/leaf.nvim",
		config = function()
			require("leaf").setup({
				theme = "dark",
				transparent = true,
				italics = {
					comments = false,
					keywords = false,
					functions = false,
					strings = false,
					variables = false,
				},
			})
		end,
	},
	{
		"navarasu/onedark.nvim",
		priority = 1000, -- make sure to load this before all the other start plugins
		config = function()
			require("onedark").setup({
				style = "warmer",
				transparent = true,
				term_colors = true,
				toggle_style_key = "<leader>ts",
			})
			require("onedark").load()
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lualine").setup({
				options = {
					theme = "onedark",
					-- ... your lualine config
				},
			})
		end,
	},
}
