return {
	"obsidian-nvim/obsidian.nvim",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-lua/plenary.nvim",
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

		frontmatter = {
			enabled = false,
		},

		templates = {
			subdir = "templates",
			date_format = "%Y-%m-%d",
			time_format = "%H:%M:%S",
		},

		-- Optimized completion settings
		completion = {
			nvim_cmp = false,
			min_chars = 2,
		},

		-- Enable UI with optimized settings
		ui = {
			enable = true,
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
				suffix = tostring(os.time())
			end
			return tostring(os.time()) .. "-" .. suffix
		end,

		-- Attachments configuration
		attachments = {
			folder = "assets/images",
			confirm_img_paste = true,
		},

		search = {
			sort_by = "modified",
			sort_reversed = true,
			max_lines = 1000,
		},

		-- Disable legacy commands
		legacy_commands = false,
	},
}
