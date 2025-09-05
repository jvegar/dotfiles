return {
	"obsidian-nvim/obsidian.nvim",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
	},
	version = "*", -- recommended, use latest release instead of latest commit
	--ft = "markdown",
	-- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
	event = {
		--   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
		--   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
		--   -- refer to `:h file-pattern` for more examples
		"BufReadPre /mnt/d/repos/learning/obsidian/obsidian-vault-jevr/*.md",
		"BufNewFile /mnt/d/repos/learning/obsidian/obsidian-vault-jevr/*.md",
	},
	---@module 'obsidian'
	---@type obsidian.config
	opts = {
		workspaces = {
			{
				name = "personal",
				path = "/mnt/d/repos/learning/obsidian/obsidian-vault-jevr/",
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
			blink = true,
			min_chars = 2,
		},
		ui = {
			-- Disable some things below here because I set these manually for all Markdown files using treesitter
			enable = false,
		},
		legacy_commands = false,
		--notes = {
		--	has_footer = false,
		--},
	},
}
