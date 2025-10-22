return {
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
				json = { "prettierd" },
				javascript = { "prettierd" },
				typescript = { "prettierd" },
				sh = { "shfmt" },
				bash = { "shfmt" },
				zsh = { "beautysh" },
				cs = { "csharpier", timeout_ms = 3000 },
			},
			formatters = {
				beautysh = {
					prepend_args = { "-i", "2" },
				},
				csharpier = {
					command = "csharpier",
					args = { "format", "--write-stdout", "--no-cache" },
					stdin = true,
					-- Add some error handling
					exit_codes = { 0 },
					condition = function(self, ctx)
						-- Only run if csharpier is available
						return vim.fn.executable("csharpier") == 1
					end,
				},
			},
			format_on_save = {
				timeout_ms = 5000, -- Increased timeout for CSharpier
				lsp_format = "never", -- Use csharpier for C# files, not LSP fallback
			},
		},
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = true,
		-- use opts = {} for passing setup options
		-- this is equivalent to setup({}) function
	},
}
