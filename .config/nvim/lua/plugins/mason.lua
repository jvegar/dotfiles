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
				"roslyn",
				"jdtls",
			},
			ui = {
				border = "rounded",
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
			-- Custom registries for roslyn
			registries = {
				"github:mason-org/mason-registry",
				"github:Crashdummyy/mason-registry",
			},
		},
	},
	{
		"mason-org/mason-lspconfig.nvim",
		opts = {
			automatic_enable = {
				exclude = { "jdtls", "roslyn" },
			},
		},
		dependencies = {
			{ "mason-org/mason.nvim", opts = {} },
			"neovim/nvim-lspconfig",
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
