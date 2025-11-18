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
	-- Mason tool installer for third-party tools
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "williamboman/mason.nvim" },
		config = function()
			require("mason-tool-installer").setup({
				ensure_installed = {
					-- LSP tools
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
					"postgres-language-server",
					-- Formatter tools
					"prettier",
					"prettierd",
					"beautysh",
					"google-java-format",
					"latexindent",
					"shfmt",
					"stylua",
					"taplo",
					"xmlformatter",
				},
				auto_update = false,
				run_on_start = true, -- Auto-install/check on startup
				start_delay = 3000, -- Optional: delay to avoid slowing down startup
			})
		end,
	},
}
