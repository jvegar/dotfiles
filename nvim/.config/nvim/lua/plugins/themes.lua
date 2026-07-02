return {
	{
		"navarasu/onedark.nvim",
		lazy = false,
		priority = 1000, -- make sure to load this before all the other start plugins
		config = function()
			require("onedark").setup({
				style = "warmer",
				transparent = true,
				term_colors = true,
				toggle_style_key = "<leader>ts",
			})
			require("onedark").load()

			-- onedark.nvim hardcodes NormalFloat/FloatBorder to bg1 regardless
			-- of `transparent`. Mason, Lazy, LSP hover, etc. link to NormalFloat
			-- by default, so they stay opaque unless we override it ourselves.
			local function fix_float_transparency()
				vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
				vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })
				vim.api.nvim_set_hl(0, "FloatTitle", { bg = "none" })
			end

			fix_float_transparency()

			-- Re-apply every time the colorscheme (re)loads, so toggling
			-- style with <leader>ts doesn't undo this.
			vim.api.nvim_create_autocmd("ColorScheme", {
				pattern = "onedark",
				callback = fix_float_transparency,
			})
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
