return {
	{
		"mason-org/mason.nvim",
		opts = {
			ui = {
				border = "rounded",
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_ninstalled = "✗",
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
			ensure_installed = {
				"bashls",
				"jsonls",
				"lua_ls",
				"jdtls",
				"yamlls",
				"ts_ls",
				"docker_language_server",
				"lemminx",
				"dockerls",
				"texlab",
			},
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
			"neovim/nvim-lspconfig",
		},
	},
}
