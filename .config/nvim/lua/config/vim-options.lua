local opt = vim.opt
local api = vim.api

-- General options
opt.number = true -- Show line numbers
opt.relativenumber = true -- Show relative line numbers
opt.cursorline = false -- Disable current line highlighting
opt.wrap = false -- Disable line wrapping
opt.breakindent = true -- Wrapped lines will respect indentation
opt.scrolloff = 8 -- Minimum lines above/below cursor
opt.sidescrolloff = 8 -- Minimum columns left/right of cursor
opt.signcolumn = "yes" -- Always show sign column
opt.numberwidth = 4 -- Set width of the number column
opt.splitbelow = true -- Horizontal splits go below current window
opt.splitright = true -- Vertical splits go to the right of current window
opt.title = true -- Enable title in window title bar
opt.confirm = true -- Ask for confirmation when closing modified buffers
opt.showcmd = false -- Disable command display in the last line
opt.ruler = false -- Disable ruler
opt.rulerformat = "%l,%v" -- Set ruler format

-- Indetation options
opt.expandtab = true -- Convert tabs to spaces
opt.tabstop = 2 -- Number of spaces per tab
opt.softtabstop = 2 -- Number of spaces per soft tab
opt.shiftwidth = 2 -- Number of spaces per indent
opt.breakindent = true -- Presever indentation in wrapped lines

-- File behavior
opt.backup = false -- Disable backup files
opt.swapfile = false -- Disable swap files
opt.writebackup = false -- Disable write backups
opt.undofile = true -- Enable persistent undo
opt.autoread = true -- Reload files changed outside of Neovim

-- Colorscheme
vim.cmd([[colorscheme leaf]])

-- dont' auto comment new line
api.nvim_create_autocmd("BufEnter", { command = [[set formatoptions-=cro]] })

-- Autocommand group for autoread
local group = api.nvim_create_augroup("AutoReadGroup", { clear = true })
api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
	group = group,
	callback = function()
		vim.cmd("checktime") -- Check if files have changed externally
	end,
	desc = "Check for file changes on focus or buffer enter",
})
