---@diagnostic disable: unused-local

return {
	"kevinhwang91/nvim-ufo",
	dependencies = "kevinhwang91/promise-async",
	config = function()
		vim.o.foldcolumn = "1" -- '0' is not bad
		vim.o.foldlevel = 99 -- Using ufo provider need a large value
		vim.o.foldlevelstart = 99
		vim.o.foldenable = false
		vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]

		-- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
		vim.keymap.set("n", "zR", require("ufo").openAllFolds)
		vim.keymap.set("n", "zM", require("ufo").closeAllFolds)

		local handler = function(virtText, lnum, endLnum, width, truncate)
			local newVirtText = {}
			local suffix = ("   %d "):format(endLnum - lnum)
			local sufWidth = vim.fn.strdisplaywidth(suffix)
			local targetWidth = width - sufWidth
			local curWidth = 0
			for _, chunk in ipairs(virtText) do
				local chunkText = chunk[1]
				local chunkWidth = vim.fn.strdisplaywidth(chunkText)
				if targetWidth > curWidth + chunkWidth then
					table.insert(newVirtText, chunk)
				else
					chunkText = truncate(chunkText, targetWidth - curWidth)
					local hlGroup = chunk[2]
					table.insert(newVirtText, { chunkText, hlGroup })
					chunkWidth = vim.fn.strdisplaywidth(chunkText)
					-- str width returned from truncate() may less than 2nd argument, need padding
					if curWidth + chunkWidth < targetWidth then
						suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
					end
					break
				end
				curWidth = curWidth + chunkWidth
			end
			table.insert(newVirtText, { suffix, "MoreMsg" })
			return newVirtText
		end

		local highlight = vim.api.nvim_set_hl
		highlight(0, "UfoFoldedEllipsis", { link = "FoldColumn" })
		highlight(0, "UfoCursorFoldedLine", { link = "CursorLine" })

		require("ufo").setup({
			provider_selector = function(bufnr, filetype, buftype)
				-- Use LSP provider for C# files if available, otherwise fall back to treesitter
				if filetype == "cs" then
					return { "lsp", "treesitter" }
				end
				return { "treesitter", "indent" }
			end,
			fold_virt_text_handler = handler,
		})
	end,
}
-- lazy.nvim
-- return {
-- 	"chrisgrieser/nvim-origami",
-- 	event = "VeryLazy",
-- 	opts = {
-- 		foldtext = {
-- 			lineCount = {
-- 				template = " %d",
-- 			},
-- 		},
-- 	},
-- 	init = function()
-- 		vim.opt.foldlevel = 99
-- 		vim.opt.foldlevelstart = 99
--
-- 		vim.opt.fillchars = {
-- 			foldopen = "",
-- 			foldclose = "",
-- 			foldsep = " ",
-- 		}
--
-- 		vim.opt.foldcolumn = "1"
--
-- 		vim.keymap.set("n", "<CR>", "za", { noremap = true, silent = true })
-- 	end,
-- }
