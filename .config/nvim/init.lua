local g = vim.g

-- Leader keys
g.mapleader = " "
g.maplocalleader = " "

require("config.ui")
require("config.lazy")
require("config.vim-options")
require("config.telescope.makefile_targets")
