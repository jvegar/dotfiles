return {
	"goolord/alpha-nvim",
	enabled = true,
	dependencies = { "nvim-tree/nvim-web-devicons", "nvim-telescope/telescope.nvim" },
	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")

		-- Set header
		dashboard.section.header.val = {
			"                                                  ",
			"     ██╗██╗   ██╗███████╗ ██████╗  █████╗ ██████╗ ",
			"     ██║██║   ██║██╔════╝██╔════╝ ██╔══██╗██╔══██╗",
			"     ██║██║   ██║█████╗  ██║  ███╗███████║██████╔╝",
			"██   ██║╚██╗ ██╔╝██╔══╝  ██║   ██║██╔══██║██╔══██╗",
			"╚█████╔╝ ╚████╔╝ ███████╗╚██████╔╝██║  ██║██║  ██║",
			" ╚════╝   ╚═══╝  ╚══════╝ ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝",
			"                                                  ",
		}

		-- Set menu
		dashboard.section.buttons.val = {
			dashboard.button("e", "  > New file", ":ene <BAR> startinsert <CR>"),
			dashboard.button("f", "󰈞  > Find file", ":Telescope find_files<CR>"),
			dashboard.button("r", "  > Recent", ":Telescope oldfiles<CR>"),
			dashboard.button("s", "  > Settings", ":e $MYVIMRC <CR>"),
			dashboard.button("q", "  > Quit NVIM", ":qa<CR>"),
		}

		-- Set footer
		dashboard.section.footer.val = require("alpha.fortune")()

		-- Send config to alpha
		alpha.setup(dashboard.opts)

		-- Disable folding on alpha buffer
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "alpha",
			callback = function()
				vim.opt_local.foldenable = false
			end,
		})
	end,
}
