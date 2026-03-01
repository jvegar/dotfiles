return {
	"yetone/avante.nvim",
	build = "make",
	event = "VeryLazy",
	version = false, -- Never set this value to "*"! Never!
	---@module 'avante'
	---@diagnostic disable-next-line: undefined-doc-name
	---@type avante.Config
	opts = {
		instructions_file = "avante.md",
		provider = "deepseek",
		providers = {
			deepseek = {
				__inherited_from = "openai",
				endpoint = "https://api.deepseek.com",
				api_key_name = "AVANTE_DEEPSEEK_API_KEY",
				model = "deepseek-coder",
				timeout = 30000, -- Timeout in milliseconds
				extra_request_body = {
					temperature = 0.75,
					max_tokens = 8192,
				},
			},
		},
	},
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		-- The below dependencies are optional,
		"echasnovski/mini.pick", -- for file_selector provider mini.pick
		"nvim-telescope/telescope.nvim", -- for file_selector provider telescope
		"hrsh7th/nvim-cmp", -- for completion provider nvim-cmp
		"ibhagwan/fzf-lua", -- for file_selector provider fzf-lua
		"stevearc/dressing.nvim", -- for input provider dressing
		"folke/snacks.nvim", -- for input provider snacks
		"nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
		"zbirenbaum/copilot.lua", -- for copilot provider
		{
			-- support for image pasting
			"HakonHarnes/img-clip.nvim",
			event = "VeryLazy",
			opts = {
				-- recommended settings
				default = {
					embed_image_as_base64 = false,
					prompt_for_file_name = false,
					drag_and_drop = {
						insert_mode = true,
					},
					-- required for windows users
					use_absolute_path = true,
				},
			},
		},
		{
			-- Make sure to set this up properly if you have lazy=true
			"MeanderingProgrammer/render-markdown.nvim",
			opts = {
				filetypes = { "markdown", "md" },
			},
			ft = { "markdown", "Avante" },
		},
	},
}
