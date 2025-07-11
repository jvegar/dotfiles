return {
	{
		"mason-org/mason.nvim",
		opts = {
			ensure_installed = {
				"prettierd",
				"stylua",
			},
		},
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"mason-org/mason.nvim",
			"mason-org/mason-lspconfig.nvim",
		},
	},
}
