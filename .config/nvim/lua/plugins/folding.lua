---@diagnostic disable: unused-local

return {
	"kevinhwang91/nvim-ufo",
	dependencies = "kevinhwang91/promise-async",
	-- event = { "BufReadPost", "BufNewFile" },
	config = function()
		-- ============================================================================
		-- Neovim fold settings
		-- ============================================================================
		vim.opt.foldcolumn = "1"
		vim.opt.foldlevel = 99
		vim.opt.foldlevelstart = 99
		vim.opt.foldenable = false
		vim.opt.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]

		-- ============================================================================
		-- Key mappings
		-- ============================================================================
		vim.keymap.set("n", "zR", require("ufo").openAllFolds)
		vim.keymap.set("n", "zM", require("ufo").closeAllFolds)

		-- ============================================================================
		-- Helper functions for virtText handler
		-- ============================================================================

		--- Calculate padding needed to align text
		---@param targetWidth number
		---@param currentWidth number
		---@return string padding string
		local function calculate_padding(targetWidth, currentWidth)
			return (" "):rep(math.max(0, targetWidth - currentWidth))
		end

		--- Build the suffix with fold information
		---@param startLnum number
		---@param endLnum number
		---@return string
		local function build_suffix(startLnum, endLnum)
			return ("   %d "):format(endLnum - startLnum)
		end

		--- Process virtText chunks and truncate if needed
		---@param virtText table
		---@param targetWidth number
		---@param truncate function
		---@return table newVirtText, number finalWidth
		local function process_chunks(virtText, targetWidth, truncate)
			local newVirtText = {}
			local curWidth = 0

			for _, chunk in ipairs(virtText) do
				local chunkText = chunk[1]
				local chunkWidth = vim.fn.strdisplaywidth(chunkText)

				if targetWidth > curWidth + chunkWidth then
					table.insert(newVirtText, chunk)
					curWidth = curWidth + chunkWidth
				else
					chunkText = truncate(chunkText, targetWidth - curWidth)
					local hlGroup = chunk[2]
					table.insert(newVirtText, { chunkText, hlGroup })

					chunkWidth = vim.fn.strdisplaywidth(chunkText)
					break
				end
			end

			return newVirtText, curWidth
		end

		-- ============================================================================
		-- Main virtText handler
		-- ============================================================================

		--- Custom fold display handler
		---@param virtText table virtual text chunks
		---@param lnum number start line number
		---@param endLnum number end line number
		---@param width number available width
		---@param truncate function truncate function
		---@return table modified virtText
		local handler = function(virtText, lnum, endLnum, width, truncate)
			-- Build suffix showing line count
			local suffix = build_suffix(lnum, endLnum)
			local sufWidth = vim.fn.strdisplaywidth(suffix)

			-- Reserve space for suffix
			local targetWidth = width - sufWidth

			-- Process and truncate chunks if needed
			local newVirtText, curWidth = process_chunks(virtText, targetWidth, truncate)

			-- Add padding if needed
			if curWidth < targetWidth then
				suffix = suffix .. calculate_padding(targetWidth, curWidth)
			end

			-- Add the suffix as the final element
			table.insert(newVirtText, { suffix, "MoreMsg" })
			return newVirtText
		end

		-- ============================================================================
		-- Highlight definitions
		-- ============================================================================
		vim.api.nvim_set_hl(0, "UfoFoldedEllipsis", { link = "FoldColumn" })
		vim.api.nvim_set_hl(0, "UfoCursorFoldedLine", { link = "CursorLine" })

		-- ============================================================================
		-- UFO configuration
		-- ============================================================================
		require("ufo").setup({
			provider_selector = function(_, filetype, _)
				-- Define provider preferences by filetype
				local providers = {
					-- Use LSP for strongly-typed languages (better accuracy for complex types)
					cs = { "lsp", "treesitter" },
					ts = { "lsp", "treesitter" },
					typescript = { "lsp", "treesitter" },
					js = { "lsp", "treesitter" },
					javascript = { "lsp", "treesitter" },

					-- Better folding for configuration files
					yaml = { "treesitter" },
					yml = { "treesitter" },
				}

				-- Return appropriate providers or default
				return providers[filetype] or { "treesitter", "indent" }
			end,

			fold_virt_text_handler = handler,
		})
	end,
}
