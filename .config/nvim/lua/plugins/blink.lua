return {
	{ "L3MON4D3/LuaSnip", keys = {} },
	{
		"saghen/blink.cmp",
		dependencies = {
			"rafamadriz/friendly-snippets",
		},
		version = "*",
		config = function()
			require("blink.cmp").setup({
				snippets = { preset = "luasnip" },
				signature = { enabled = true },
				sources = {
					default = { "lsp", "path", "snippets", "buffer" },
				},
				keymap = {
					preset = "enter",
				},
				cmdline = {
					enabled = false,
					completion = { menu = { auto_show = true } },
					keymap = {
						["<CR>"] = { "accept_and_enter", "fallback" },
					},
				},
				completion = {
					list = {
						selection = {
							-- Forcefully disable pre-selection and auto-insertion
							preselect = function()
								return true
							end,
							auto_insert = function()
								return false
							end,
						},
					},
					ghost_text = { enabled = true },
					--keymap = {
					--  ["<CR>"] = { "select_and_accept", "fallback" },
					--  ["<C-n>"] = { "select_next", "fallback" },
					--  ["<C-p>"] = { "select_prev", "fallback" },
					--  ["<C-Space>"] = { "show", "fallback" },
					--},
					accept = {
						auto_brackets = { enabled = true },
					},
				},
			})

			require("luasnip.loaders.from_vscode").lazy_load()
		end,
	},
}
