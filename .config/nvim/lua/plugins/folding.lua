-- return {
-- 	"kevinhwang91/nvim-ufo",
-- 	dependencies = "kevinhwang91/promise-async",
-- 	config = function()
-- 		vim.o.foldcolumn = "1" -- '0' is not bad
-- 		vim.o.foldlevel = 99 -- Using ufo provider need a large value
-- 		vim.o.foldlevelstart = 99
-- 		vim.o.foldenable = true
-- 		vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
--
-- 		-- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
-- 		vim.keymap.set("n", "zR", require("ufo").openAllFolds)
-- 		vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
--
-- 		require("ufo").setup({
-- 			provider_selector = function(bufnr, filetype, buftype)
-- 				-- Use LSP provider for C# files if available, otherwise fall back to treesitter
-- 				if filetype == "cs" then
-- 					return { "lsp", "treesitter" }
-- 				end
-- 				return { "treesitter", "indent" }
-- 			end,
-- 		})
-- 	end,
-- }
-- lazy.nvim
return {
	"chrisgrieser/nvim-origami",
	event = "VeryLazy",
	opts = {
		foldtext = {
			lineCount = {
				template = " %d",
			},
		},
	},
	init = function()
		vim.opt.foldlevel = 99
		vim.opt.foldlevelstart = 99

		local fold_util = require("core.code_folds")

		vim.keymap.set("n", "<CR>", "za", { noremap = true, silent = true })
		vim.keymap.set("n", "[[", fold_util.goto_previous_fold, { noremap = true, silent = true })
		vim.keymap.set("n", "]]", "zj", { noremap = true, silent = true })

		-- Optimized autocmds - use less frequent events for initial setup
		vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter", "LspAttach" }, {
			callback = function(opts)
				-- Immediate treesitter fallback for fast initial display
				fold_util.update_ranges_treesitter(opts.buf)
				-- Then trigger the full update (with LSP) after a short delay
				vim.fn.timer_start(50, function()
					if vim.api.nvim_buf_is_valid(opts.buf) then
						fold_util.update_ranges(opts.buf)
					end
				end)
			end,
		})

		-- Only update on significant changes, not every text change
		vim.api.nvim_create_autocmd({ "InsertLeave", "TextChangedI" }, {
			callback = function(opts)
				-- Use a longer debounce for text changes (300ms)
				vim.fn.timer_start(300, function()
					if vim.api.nvim_buf_is_valid(opts.buf) then
						fold_util.update_ranges(opts.buf)
					end
				end)
			end,
		})

		local last_row = nil
		local cursor_moved_timer = nil
		vim.api.nvim_create_autocmd("CursorMoved", {
			callback = function(opts)
				local row = vim.api.nvim_win_get_cursor(0)[1]
				if row ~= last_row then
					last_row = row
					-- Small debounce for cursor movement to reduce frequency
					if cursor_moved_timer then
						vim.fn.timer_stop(cursor_moved_timer)
					end
					cursor_moved_timer = vim.fn.timer_start(50, function()
						fold_util.update_current_fold(row, opts.buf)
					end)
				end
			end,
		})

		vim.api.nvim_create_autocmd({ "BufUnload", "BufWipeout" }, {
			callback = function(opts)
				fold_util.clear(opts.buf)
			end,
		})

		vim.opt.statuscolumn = "%!v:lua.StatusCol()"
		function _G.StatusCol()
			return fold_util.statuscol()
		end
	end,
}
