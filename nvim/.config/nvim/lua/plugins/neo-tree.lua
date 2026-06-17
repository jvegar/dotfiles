return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	config = function()
		require("neo-tree").setup({
			filesystem = {
				filtered_items = {
					hide_dotfiles = false,
					hide_gitignored = false,
					hide_by_name = {
						"node_modules",
						".DS_Store",
						".git",
					},
					always_show = { ".gitignore" },
				},
				follow_current_file = { enabled = true }, -- Updated line
				hijack_netrw_behavior = "open_current",
				find_root = true,
			},
			window = {
				position = "left",
				width = 25,
				mappings = {
					["<space>"] = "toggle_node",
					["<CR>"] = "open",
					["S"] = "split_with_window_picker",
					["s"] = "vsplit_with_window_picker",
					["t"] = "open_tabnew",
				},
			},
			buffers = {
				show_unloaded = true,
			},
		})

		-- Keymaps
		vim.keymap.set("n", "<C-n>", ":Neotree toggle reveal filesystem left<CR>", {})
		vim.keymap.set("n", "<leader>bf", ":Neotree buffers reveal float<CR>", {})
		vim.keymap.set("n", "<leader>gs", ":Neotree git_status<CR>", {})
	end,
}
