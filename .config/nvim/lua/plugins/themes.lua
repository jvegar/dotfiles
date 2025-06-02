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
		"zootedb0t/citruszest.nvim",
		lazy = false,
		priority = 1000,
	},
	{
		"yorik1984/newpaper.nvim",
		priority = 1000,
		config = function()
			require("newpaper").setup({
				style = "dark",
        lightness = -0.1,
        saturation = -0.1,
			})
		end,
	},
  {
    "craftzdog/solarized-osaka.nvim",
    lazy = true,
    priority = 1000,
    opts = function()
      return {
        transparent = true
      }
    end
  }
}
