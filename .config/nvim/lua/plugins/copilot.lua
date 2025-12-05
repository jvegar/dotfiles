return {
	{
		"github/copilot.vim",
		enabled = true,
		config = function()
			vim.g.copilot_enabled = false
		end,
	},
	{
		"folke/which-key.nvim",
		optional = true,
		opts = {
			spec = {
				{ "<leader>a", group = "ai", mode = { "n", "v" } },
				{ "gm", group = "+Copilot chat" },
				{ "gmh", desc = "Show help" },
				{ "gmd", desc = "Show diff" },
				{ "gmp", desc = "Show system prompt" },
				{ "gms", desc = "Show selection" },
				{ "gmy", desc = "Yank diff" },
				{ "<leader>gm", group = "Copilot Chat" },
			},
		},
	},

	{
		"CopilotC-Nvim/CopilotChat.nvim",
		branch = "main",
		-- Do not use branch and version together, either use branch or version
		dependencies = {
			{ "nvim-lua/plenary.nvim" },
			"ibhagwan/fzf-lua",
		},
		opts = {
			-- AI model configuration
			model = "gpt-4.1",
			temperature = 0.1,

			-- Default context sharing
			-- selection will be set in config function

			-- Window layout
			window = {
				layout = "float",
				width = 80,
				height = 20,
				border = "rounded",
				title = "🤖 AI Assistant",
				relative = "editor",
				zindex = 100,
			},

			-- Headers customization
			question_header = "## User ",
			answer_header = "## Copilot ",
			error_header = "## Error ",

			-- Prompts configuration
			prompts = {
				-- Code related prompts
				Explain = {
					prompt = "Please explain how the following code works.",
					description = "Detailed code explanation",
				},
				Review = {
					prompt = "Please review the following code and provide suggestions for improvement.",
					description = "Code review with suggestions",
				},
				Tests = {
					prompt = "Please explain how the selected code works, then generate unit tests for it.",
					description = "Generate unit tests",
				},
				Refactor = {
					prompt = "Please refactor the following code to improve its clarity and readability.",
					description = "Code refactoring",
				},
				FixCode = {
					prompt = "Please fix the following code to make it work as intended.",
					description = "Fix broken code",
				},
				FixError = {
					prompt = "Please explain the error in the following text and provide a solution.",
					description = "Fix errors in text",
				},
				BetterNamings = {
					prompt = "Please provide better names for the following variables and functions.",
					description = "Improve naming",
				},
				Documentation = {
					prompt = "Please provide documentation for the following code.",
					description = "Generate documentation",
				},
				SwaggerApiDocs = {
					prompt = "Please provide documentation for the following API using Swagger.",
					description = "Generate Swagger API docs",
				},
				SwaggerJsDocs = {
					prompt = "Please write JSDoc for the following API using Swagger.",
					description = "Generate Swagger JSDoc",
				},
				-- Text related prompts
				Summarize = {
					prompt = "Please summarize the following text.",
					description = "Text summarization",
				},
				Spelling = {
					prompt = "Please correct any grammar and spelling errors in the following text.",
					description = "Grammar and spelling correction",
				},
				Wording = {
					prompt = "Please improve the grammar and wording of the following text.",
					description = "Improve wording and grammar",
				},
				Concise = {
					prompt = "Please rewrite the following text to make it more concise.",
					description = "Make text more concise",
				},
				CopilotChatReviewStaged = {
					prompt = "#gitdiff:staged please review this code",
					system_prompt = "You are very good at code review.",
					mapping = "<leader>as",
					description = "Code review for staged changes",
				},
			},

			-- Behavior options
			auto_follow_cursor = false,
			show_help = false,
			chat_autocomplete = true,
			auto_fold = true,
			highlight_selection = true,
			clear_chat_on_new_prompt = false,

			-- Mappings
			mappings = {
				-- Use tab for completion
				complete = {
					detail = "Use @<Tab> or /<Tab> for options.",
					insert = "<Tab>",
				},
				-- Close the chat
				close = {
					normal = "q",
					insert = "<C-c>",
				},
				-- Reset the chat buffer
				reset = {
					normal = "<C-x>",
					insert = "<C-x>",
				},
				-- Submit the prompt to Copilot
				submit_prompt = {
					normal = "<CR>",
					insert = "<C-CR>",
				},
				-- Accept the diff
				accept_diff = {
					normal = "<C-y>",
					insert = "<C-y>",
				},
				-- Yank the diff in the response to register
				yank_diff = {
					normal = "gmy",
				},
				-- Show the diff
				show_diff = {
					normal = "gmd",
				},
				show_info = {
					normal = "gmp",
				},
				show_context = {
					normal = "gms",
				},
				-- Show help
				show_help = {
					normal = "gmh",
				},
			},

			-- History and logging
			history_path = vim.fn.stdpath("data") .. "/copilotchat_history",
			log_level = "info",
		},
		config = function(_, opts)
			local chat = require("CopilotChat")
			local select = require("CopilotChat.select")

			-- Try to get hostname, fallback to empty string if hostname command not available
			local hostname = ""
			local hostname_handle = io.popen("hostname 2>/dev/null")
			if hostname_handle then
				hostname = hostname_handle:read("*a"):gsub("%s+", "")
				hostname_handle:close()
			end
			local user = vim.env.USER or (hostname ~= "" and hostname) or "User"
			opts.question_header = "  " .. user .. " "
			opts.answer_header = "  Copilot "
			opts.selection = select.unnamed

			chat.setup(opts)

			-- Restore legacy commands for compatibility
			vim.api.nvim_create_user_command("CopilotChatVisual", function(args)
				chat.ask(args.args, { selection = select.visual })
			end, { nargs = "*", range = true })

			vim.api.nvim_create_user_command("CopilotChatInline", function(args)
				chat.ask(args.args, {
					selection = select.visual,
					window = {
						layout = "float",
						relative = "cursor",
						width = 1,
						height = 0.4,
						row = 1,
					},
				})
			end, { nargs = "*", range = true })

			vim.api.nvim_create_user_command("CopilotChatBuffer", function(args)
				chat.ask(args.args, { selection = select.buffer })
			end, { nargs = "*", range = true })

			-- Custom buffer for CopilotChat
			vim.api.nvim_create_autocmd("BufEnter", {
				pattern = "copilot-*",
				callback = function()
					vim.opt_local.relativenumber = true
					vim.opt_local.number = true

					-- Get current filetype and set it to markdown if the current filetype is copilot-chat
					local ft = vim.bo.filetype
					if ft == "copilot-chat" then
						vim.bo.filetype = "markdown"
					end
				end,
			})
		end,
		keys = {
			-- Provide code review for staged changes
			{
				"<leader>as",
				"<cmd>CopilotChatReviewStaged<cr>",
				desc = "CopilotChat - Review staged changes",
			},
			-- Show prompts actions
			{
				"<leader>ap",
				function()
					local actions = require("CopilotChat.actions")
					require("CopilotChat.integrations.fzflua").pick(actions.prompt_actions())
				end,
				desc = "CopilotChat - Prompt actions",
			},
			{
				"<leader>ap",
				function()
					local actions = require("CopilotChat.actions")
					local select = require("CopilotChat.select")
					require("CopilotChat.integrations.fzflua").pick(actions.prompt_actions({
						selection = select.visual,
					}))
				end,
				mode = "x",
				desc = "CopilotChat - Prompt actions (visual)",
			},
			-- Code related commands
			{ "<leader>ae", "<cmd>CopilotChatExplain<cr>", desc = "CopilotChat - Explain code" },
			{ "<leader>at", "<cmd>CopilotChatTests<cr>", desc = "CopilotChat - Generate tests" },
			{ "<leader>ar", "<cmd>CopilotChatReview<cr>", desc = "CopilotChat - Review code" },
			{ "<leader>aR", "<cmd>CopilotChatRefactor<cr>", desc = "CopilotChat - Refactor code" },
			{ "<leader>an", "<cmd>CopilotChatBetterNamings<cr>", desc = "CopilotChat - Better Naming" },
			-- Chat with Copilot in visual mode
			{
				"<leader>av",
				":CopilotChatVisual",
				mode = "x",
				desc = "CopilotChat - Open in vertical split",
			},
			{
				"<leader>ax",
				":CopilotChatInline<cr>",
				mode = "x",
				desc = "CopilotChat - Inline chat",
			},
			-- Custom input for CopilotChat
			{
				"<leader>ai",
				function()
					local input = vim.fn.input("Ask Copilot: ")
					if input ~= "" then
						vim.cmd("CopilotChat " .. input)
					end
				end,
				desc = "CopilotChat - Ask input",
			},
			-- Generate commit message based on the git diff
			{
				"<leader>am",
				"<cmd>CopilotChatCommit<cr>",
				desc = "CopilotChat - Generate commit message for all changes",
			},
			-- Quick chat with Copilot
			{
				"<leader>aq",
				function()
					local input = vim.fn.input("Quick Chat: ")
					if input ~= "" then
						vim.cmd("CopilotChatBuffer " .. input)
					end
				end,
				desc = "CopilotChat - Quick chat",
			},
			-- Debug
			{ "<leader>ad", "<cmd>CopilotChatDebugInfo<cr>", desc = "CopilotChat - Debug Info" },
			-- Fix the issue with diagnostic
			{ "<leader>af", "<cmd>CopilotChatFix<cr>", desc = "CopilotChat - Fix Diagnostic" },
			-- Clear buffer and chat history
			{ "<leader>al", "<cmd>CopilotChatReset<cr>", desc = "CopilotChat - Clear buffer and chat history" },
			-- Toggle Copilot Chat
			{ "<leader>av", "<cmd>CopilotChatToggle<cr>", desc = "CopilotChat - Toggle" },
			-- Copilot Chat Models
			{ "<leader>a?", "<cmd>CopilotChatModels<cr>", desc = "CopilotChat - Select Models" },
		},
	},
	{
		"folke/edgy.nvim",
		optional = true,
		opts = function(_, opts)
			opts.right = opts.right or {}
			table.insert(opts.right, {
				ft = "copilot-chat",
				title = "Copilot Chat",
				size = { width = 50 },
			})
		end,
	},
}
