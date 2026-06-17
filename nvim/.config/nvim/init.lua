local g = vim.g

-- Leader keys
g.mapleader = " "
g.maplocalleader = " "

require("config.ui")
require("core.lazy")
require("core.lsp")
require("config.autocmds")
require("config.vim-options")
require("config.keymaps")
