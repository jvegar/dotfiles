return {
	"tpope/vim-dadbod",
	dependencies = {
		"kristijanhusak/vim-dadbod-ui",
		"kristijanhusak/vim-dadbod-completion",
	},
	config = function()
		vim.g.db = vim.env.DATABASE_URL_DADBOB
		vim.g.db_ui_env_variable_url = "DATABASE_URL_DADBOB"
	end,
}
