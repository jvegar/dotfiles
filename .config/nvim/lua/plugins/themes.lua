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
			})
		end,
	},
}
