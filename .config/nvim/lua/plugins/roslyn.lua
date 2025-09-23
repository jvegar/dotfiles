return {
	"seblyng/roslyn.nvim",
	---@module 'roslyn.config'
	---@type RoslynNvimConfig
	opts = {
		-- Configure Roslyn to provide better folding support
		settings = {
			csharp = {
				-- Enable semantic highlighting and folding ranges
				semantic_highlighting = true,
				-- Ensure folding ranges are provided
				folding = {
					enabled = true,
				},
			},
		},
	},
}
