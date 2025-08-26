local augroup = vim.api.nvim_create_augroup("custom-ui", { clear = true })

vim.api.nvim_create_autocmd("ColorScheme", {
	group = augroup,
	pattern = "*",
	callback = function()
		local highlights = {
			FloatBorder = { fg = "#428891" },
			NormalFloat = { bg = "none" },
			LazyNormal = { bg = "none" },
		}

		for group, settings in pairs(highlights) do
			vim.api.nvim_set_hl(0, group, settings)
		end
	end,
})
