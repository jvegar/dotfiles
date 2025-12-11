return {
	"lervag/vimtex",
	ft = { "tex" },
	init = function()
		-- Platform-specific PDF viewer
		if vim.fn.has("mac") == 1 then
			vim.g.vimtex_view_method = "skim"
			vim.g.vimtex_view_skim_sync = 1
			vim.g.vimtex_view_skim_activate = 1
		elseif vim.fn.has("unix") == 1 then
			vim.g.vimtex_view_method = "zathura"
		-- Alternative: 'evince' or 'okular'
		elseif vim.fn.has("win32") == 1 then
			vim.g.vimtex_view_general_viewer = "SumatraPDF"
			vim.g.vimtex_view_general_options = "-reuse-instance -forward-search @tex @line @pdf"
		end

		-- Common settings
		vim.g.vimtex_compiler_method = "latexmk"
		vim.g.vimtex_quickfix_mode = 0
		vim.g.vimtex_fold_enabled = false  -- Disable vimtex folding in favor of UFO

		-- Optional: suppress some warnings
		vim.g.vimtex_quickfix_ignore_filters = {
			"Underfull",
			"Overfull",
		}
	end,
}
