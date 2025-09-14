return {
	"obsidian-nvim/obsidian.nvim",
	--enabled = false,
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
	},
	version = "*",
	lazy = true,
	event = {
		"BufReadPre " .. vim.env.OBSIDIAN_BASE .. "/*.md",
		"BufNewFile " .. vim.env.OBSIDIAN_BASE .. "/*.md",
	},
	---@module 'obsidian'
	---@type obsidian.config
	opts = {
		workspaces = {
			{
				name = "personal",
				path = vim.env.OBSIDIAN_BASE .. "/",
			},
		},

		notes_subdir = "notes",
		new_notes_location = "notes_subdir",

		disable_frontmatter = true,
		templates = {
			subdir = "templates",
			date_format = "%Y-%m-%d",
			time_format = "%H:%M:%S",
		},

		-- Optimized completion settings
		completion = {
			nvim_cmp = false,
			blink = true, -- Enable blink.cmp for faster autocomplete
			min_chars = 2,
		},

		-- Enable UI with optimized settings
		ui = {
			enable = true,
			conceallevel = 2,
			max_file_length = 10000,
		},

		-- Performance optimizations
		picker = {
			name = "telescope.nvim",
			note_mappings = {
				new = "<C-x>",
				insert_link = "<C-l>",
			},
			tag_mappings = {
				tag_note = "<C-x>",
				insert_tag = "<C-l>",
			},
			sort_by = "modified",
			sort_reversed = true,
		},

		-- Daily notes configuration
		daily_notes = {
			folder = "daily",
			template = "templates/daily.md",
		},

		-- Note ID generation
		note_id_func = function(title)
			local suffix = ""
			if title ~= nil then
				suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
			else
				suffix = os.time()
			end
			return tostring(os.time()) .. "-" .. suffix
		end,

		-- Attachments configuration
		attachments = {
			img_folder = "assets/images",
			confirm_img_paste = true,
		},

		search = {
			rg_args = { "--glob", "!.git/*", "--glob", "!assets/*" },
		},

		-- Search optimization
		search_max_lines = 500,

		-- URL handling
		follow_url_func = function(url)
			vim.fn.jobstart({ "xdg-open", url })
		end,

		-- Performance settings
		disable_update = false,
		footer = {
			enabled = true,
			--format = "({{words}} words)",
		},
		--notes = {
		--	has_footer = false,
		--},

		-- Disable legacy commands
		legacy_commands = false,
	},
}
