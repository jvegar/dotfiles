return {
	"seblyng/roslyn.nvim",
	---@module 'roslyn.config'
	---@type RoslynNvimConfig
	opts = {
		-- Configure Roslyn to provide better folding support and formatting
		settings = {
			csharp = {
				-- Enable semantic highlighting and folding ranges
				semantic_highlighting = true,
				-- Ensure folding ranges are provided
				folding = {
					enabled = true,
				},
			},
			-- Enable formatting and organize imports
			["csharp|formatting"] = {
				dotnet_organize_imports_on_format = true,
			},
		},
	},
}
