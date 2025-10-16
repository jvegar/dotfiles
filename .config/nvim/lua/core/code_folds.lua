local M = {}

local fold_ranges = {} -- { [bufnr] = { { start_line = <1 based>, end_line = <1 based> }, }, }
local fold_ranges_map = {} -- { [bufnr] = { [start_line] = { start_line = <1 based>, end_line = <1 based> }, }, }
local current_fold = nil -- { start_line = <1 based>, end_line = <1 based> }
local update_timers = {} -- { [bufnr] = timer_id }
local statuscol_cache = {} -- { [cache_key] = cached_result }
local cache_version = {} -- { [bufnr] = version_number }

function M.update_ranges(bufnr)
	-- Cancel any existing timer for this buffer
	if update_timers[bufnr] then
		vim.fn.timer_stop(update_timers[bufnr])
		update_timers[bufnr] = nil
	end

	-- Provide immediate treesitter fallback
	M.update_ranges_treesitter(bufnr)

	-- Schedule LSP request with debouncing
	update_timers[bufnr] = vim.fn.timer_start(100, function()
		M._do_update_ranges(bufnr)
		update_timers[bufnr] = nil
	end)
end

function M._do_update_ranges(bufnr)
	if not vim.api.nvim_buf_is_valid(bufnr) then
		return
	end

	local client = vim.lsp.get_clients({ bufnr = bufnr, method = "textDocument/foldingRange" })[1]

	-- Try LSP first
	if client then
		local params = { textDocument = { uri = vim.uri_from_bufnr(bufnr) } }
		local tick = vim.b[bufnr].changedtick

		client:request("textDocument/foldingRange", params, function(err, ranges)
			if err or not ranges or not vim.api.nvim_buf_is_valid(bufnr) or tick ~= vim.b[bufnr].changedtick then
				-- Keep treesitter fallback, don't retry
				return
			end

			-- Rebuild fold ranges as a map for O(1) in statuscol
			local ranges_map = {}
			local processed_ranges = {}
			for i, range in ipairs(ranges) do
				processed_ranges[i] = {
					start_line = range.startLine + 1,
					end_line = range.endLine + 1,
				}
				ranges_map[range.startLine + 1] = processed_ranges[i]
			end

			-- Sort fold ranges for goto prev fold search
			table.sort(processed_ranges, function(a, b)
				return a.start_line < b.start_line
			end)

			fold_ranges_map[bufnr] = ranges_map
			fold_ranges[bufnr] = processed_ranges

			-- Invalidate cache - status column will update automatically
			cache_version[bufnr] = (cache_version[bufnr] or 0) + 1
			statuscol_cache = {}
		end)
	end
end

-- Debug function to check fold status
function M.debug_folds(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()
	local client = vim.lsp.get_clients({ bufnr = bufnr, method = "textDocument/foldingRange" })[1]
	local ranges = fold_ranges[bufnr]

	print("Fold debug for buffer " .. bufnr .. ":")
	print("LSP client available: " .. (client and "yes" or "no"))
	print("Fold ranges cached: " .. (ranges and #ranges or "0"))
	if ranges then
		for i, range in ipairs(ranges) do
			print("  Fold " .. i .. ": lines " .. range.start_line .. "-" .. range.end_line)
		end
	end
end

-- Fallback treesitter folding
function M.update_ranges_treesitter(bufnr)
	local ranges = {}
	local ranges_map = {}

	-- Simple indent-based folding as fallback
	local lines = vim.api.nvim_buf_line_count(bufnr)
	local prev_indent = 0
	local fold_start = nil

	for lnum = 1, lines do
		local line = vim.api.nvim_buf_get_lines(bufnr, lnum - 1, lnum, false)[1]
		if line then
			local indent = line:match("^%s*"):len()
			local is_empty = line:match("^%s*$")
			local is_comment = line:match("^%s*//") or line:match("^%s*/%*")

			if not is_empty and not is_comment then
				if indent > prev_indent and fold_start == nil then
					-- Start of a potential fold
					fold_start = lnum
				elseif indent < prev_indent and fold_start then
					-- End of a fold
					if lnum - 1 > fold_start then
						local range = {
							start_line = fold_start,
							end_line = lnum - 1,
						}
						table.insert(ranges, range)
						ranges_map[fold_start] = range
					end
					fold_start = nil
				end
				prev_indent = indent
			end
		end
	end

	-- Handle final fold
	if fold_start and lines > fold_start then
		local range = {
			start_line = fold_start,
			end_line = lines,
		}
		table.insert(ranges, range)
		ranges_map[fold_start] = range
	end

	-- Sort fold ranges
	table.sort(ranges, function(a, b)
		return a.start_line < b.start_line
	end)

	fold_ranges_map[bufnr] = ranges_map
	fold_ranges[bufnr] = ranges
end

function M.update_current_fold(row, bufnr)
	local ranges = fold_ranges[bufnr]
	if not ranges then
		return nil
	end

	local best_range = nil

	for i = 1, #ranges do
		local range = ranges[i]
		if range.start_line > row then
			break
		end

		if row <= range.end_line then
			best_range = range
		end
	end

	current_fold = best_range
end

function M.clear(bufnr)
	fold_ranges[bufnr] = nil
	fold_ranges_map[bufnr] = nil
	cache_version[bufnr] = nil
	-- Clear relevant cache entries
	for key, _ in pairs(statuscol_cache) do
		if key:match("^%d+:" .. bufnr .. ":") then
			statuscol_cache[key] = nil
		end
	end
	-- Clear timer if exists
	if update_timers[bufnr] then
		vim.fn.timer_stop(update_timers[bufnr])
		update_timers[bufnr] = nil
	end
end

function M.goto_previous_fold()
	local bufnr = vim.api.nvim_get_current_buf()
	local ranges = fold_ranges[bufnr]
	if not ranges or #ranges == 0 then
		return
	end

	local row = vim.api.nvim_win_get_cursor(0)[1]

	for i = #ranges, 1, -1 do
		local start_line = ranges[i].start_line

		if start_line < row then
			return vim.api.nvim_win_set_cursor(0, { start_line, 0 })
		end
	end
end

function M.statuscol()
	local winid = vim.g.statusline_winid
	local bufnr = vim.api.nvim_win_get_buf(winid)
	local lnum = vim.v.lnum

	-- Create cache key
	local cache_key = string.format("%d:%d:%d", winid, bufnr, lnum)
	local current_version = cache_version[bufnr] or 0
	local cached_result = statuscol_cache[cache_key]

	-- Return cached result if available and version matches
	if cached_result and cached_result.version == current_version then
		return cached_result.text
	end

	local fold_map = fold_ranges_map[bufnr]
	if not fold_map then
		local result = "%l   "
		statuscol_cache[cache_key] = { text = result, version = current_version }
		return result
	end

	local this_range = fold_map[lnum]
	if not this_range then
		local result = "%l   "
		statuscol_cache[cache_key] = { text = result, version = current_version }
		return result
	end

	local closed = (vim.fn.foldclosed(lnum) == lnum)
	local icon = closed and "" or ""

	local hl = "FoldColumn"
	local cursor_fold = current_fold
	if cursor_fold and this_range.start_line == cursor_fold.start_line then
		hl = "CursorLineNr"
	end

	local result = "%l " .. "%#" .. hl .. "#" .. icon .. "%* "
	statuscol_cache[cache_key] = { text = result, version = current_version }
	return result
end

-- Create a command to debug folding
vim.api.nvim_create_user_command('DebugFolds', function()
	M.debug_folds()
end, { desc = 'Debug folding information for current buffer' })

return M