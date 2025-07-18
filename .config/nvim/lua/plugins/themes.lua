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
}
