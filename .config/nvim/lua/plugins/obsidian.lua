return {
	"obsidian-nvim/obsidian.nvim",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
	},
	version = "*", -- recommended, use latest release instead of latest commit
	--ft = "markdown",
	-- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
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

		-- see below for full list of options 👇
		notes_subdir = "notes",
		new_notes_location = "notes_subdir",

		disable_frontmatter = true,
		templates = {
			subdir = "templates",
			date_format = "%Y-%m-%d",
			time_format = "%H:%M:%S",
		},
		-- key mappings are now configured separately, see: https://github.com/obsidian-nvim/obsidian.nvim/wiki/Keymaps
		completion = {
			nvim_cmp = false,
			blink = false,
			min_chars = 2,
		},
		ui = {
			-- Disable some things below here because I set these manually for all Markdown files using treesitter
			enable = false,
		},
		legacy_commands = false,
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
		follow_url_func = function(url)
			vim.fn.jobstart({ "xdg-open", url })
		end,
		-- Reduce background processing
		disable_update = true,
		notes = {
			has_footer = false,
		},
	},
}
