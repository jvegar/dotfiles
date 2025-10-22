vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
	callback = function(event)
		local map = function(keys, func, desc)
			vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
		end

		-- defaults:
		-- https://neovim.io/doc/user/news-0.11.html#_defaults

		map("gl", vim.diagnostic.open_float, "Open Diagnostic Float")
		map("K", vim.lsp.buf.hover, "Hover Documentation")
		map("gs", vim.lsp.buf.signature_help, "Signature Help")
		map("gD", vim.lsp.buf.declaration, "Goto Declaration")
		map("<leader>la", vim.lsp.buf.code_action, "Code Action")
		map("<leader>lr", vim.lsp.buf.rename, "Rename all references")
		map("<leader>lf", vim.lsp.buf.format, "Format")
		map("<leader>v", "<cmd>vsplit | lua vim.lsp.buf.definition()<cr>", "Goto Definition in Vertical Split")

		-- Auto-format on save for Java files
		if vim.bo[event.buf].filetype == "java" then
			vim.api.nvim_create_autocmd("BufWritePre", {
				buffer = event.buf,
				callback = function()
					vim.lsp.buf.format({ async = false })
				end,
			})
		end

		local function client_supports_method(client, method, bufnr)
			if vim.fn.has("nvim-0.11") == 1 then
				return client:supports_method(method, bufnr)
			else
				return client.supports_method(method, { bufnr = bufnr })
			end
		end

		local client = vim.lsp.get_client_by_id(event.data.client_id)

		-- if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_completion, event.buf) then
		--   vim.lsp.completion.enable(true, client.id, event.buf, { autotrigger = true })
		-- end

		if
			client
			and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf)
		then
			local highlight_augroup = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })

			-- When cursor stops moving: Highlights all instances of the symbol under the cursor
			-- When cursor moves: Clears the highlighting
			vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
				buffer = event.buf,
				group = highlight_augroup,
				callback = vim.lsp.buf.document_highlight,
			})
			vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
				buffer = event.buf,
				group = highlight_augroup,
				callback = vim.lsp.buf.clear_references,
			})

			-- When LSP detaches: Clears the highlighting
			vim.api.nvim_create_autocmd("LspDetach", {
				group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
				callback = function(event2)
					vim.lsp.buf.clear_references()
					vim.api.nvim_clear_autocmds({ group = "lsp-highlight", buffer = event2.buf })
				end,
			})
		end
	end,
})

-- Custom gf mapping for Obsidian wiki links (with debugging)
vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
	pattern = "*.md",
	callback = function()
		local obsidian_base = vim.env.OBSIDIAN_BASE
		local current_file = vim.fn.expand("%:p")
		local file_matches = obsidian_base and current_file:sub(1, #obsidian_base) == obsidian_base

		if obsidian_base and file_matches then

			vim.keymap.set("n", "gf", function()
				local line = vim.api.nvim_get_current_line()
				local col = vim.api.nvim_win_get_cursor(0)[2]

				-- Find wiki link under cursor: [[note]]
				local wiki_link = nil
				local link_start, link_end = nil, nil

				-- Search for all wiki links in the line
				for start_pos, link, end_pos in line:gmatch("()%[%[([^%]]+)%]%]()") do
					-- Check if cursor is within this link
					if col >= start_pos - 2 and col <= end_pos + 2 then -- Include brackets in range
						wiki_link = link
						link_start, link_end = start_pos - 2, end_pos + 2
						break
					end
				end

				if wiki_link then
					-- Use obsidian to follow the link
					local success, result = pcall(function()
						vim.cmd("Obsidian follow_link")
					end)
					if not success then
						vim.notify("Failed to follow obsidian link: " .. result, vim.log.levels.ERROR)
					end
				else
					-- Fall back to default gf behavior for regular file paths
					local success, result = pcall(function()
						vim.cmd("normal! gf")
					end)
					if not success then
						vim.notify("Can't find file: " .. result, vim.log.levels.ERROR)
					end
				end
			end, { buffer = true, desc = "Follow link (wiki link or file path)" })
		end
	end,
})

