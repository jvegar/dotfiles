return {
	{
		"mason-org/mason.nvim",
		opts = {
			ensure_installed = {
				"prettierd",
				"stylua",
				"csharp-language-server",
				"shfmt",
				"shellcheck",
				"lua-language-server",
			},
			ui = {
				border = "rounded",
			},
			registries = {
				"github:mason-org/mason-registry",
				"github:Crashdummyy/mason-registry",
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
