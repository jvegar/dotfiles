function OpenTmuxPopup()
	local cmd = "bash $HOME/.config/scripts/toggle_tmux_popup.sh"
	vim.fn.system(cmd)
end

-- Keymap for saving file in NeoVim
vim.keymap.set("n", "<leader>s", ":w<CR>", { noremap = true, silent = true })
-- Keymap for getting current full path
vim.keymap.set("n", "<leader>fp", function()
	local fullpath = vim.fn.expand("%:p")
	vim.fn.setreg("+", fullpath)
	print(fullpath .. " full path copied to clipboard.")
end, { desc = "Copy full file path" })
-- Keymap for getting relative path
vim.keymap.set("n", "<leader>rp", function()
	local relpath = vim.fn.expand("%:.")
	vim.fn.setreg("+", relpath)
	print(relpath .. " relative path copied to clipboard.")
end, { desc = "Copy relative path" })
-- Keymap for yanking to clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
-- Keymap for managing Tmux popups
vim.keymap.set("n", "<leader>p", ":lua OpenTmuxPopup()<CR>", { noremap = true, silent = true })
-- Keymap for go-to-definition
vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, { noremap = true, silent = true, desc = "Go to definition" })
-- Keymap for go-to-implementation
vim.keymap.set(
	"n",
	"<leader>gi",
	vim.lsp.buf.implementation,
	{ noremap = true, silent = true, desc = "Go to implementation" }
)
-- Keymap for go-to-references
vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, { noremap = true, silent = true, desc = "Go to references" })

-- Obsidian keymaps
vim.keymap.set(
	"n",
	"<leader>on",
	":Obsidian template note<cr>",
	{ noremap = true, silent = true, desc = "Insert template" }
)

-- Buffer navigation
vim.keymap.set("n", "<leader>bn", ":bnext<CR>", { noremap = true, silent = true, desc = "Next buffer" })
vim.keymap.set("n", "<leader>bp", ":bprevious<CR>", { noremap = true, silent = true, desc = "Previous buffer" })
vim.keymap.set("n", "<leader>bd", ":bdelete<CR>", { noremap = true, silent = true, desc = "Delete buffer" })
vim.keymap.set("n", "<leader>bl", ":ls<CR>", { noremap = true, silent = true, desc = "List buffers" })

-- Alternative: Use shift+h/l for faster buffer switching
vim.keymap.set("n", "<S-l>", ":bnext<CR>", { noremap = true, silent = true, desc = "Next buffer" })
vim.keymap.set("n", "<S-h>", ":bprevious<CR>", { noremap = true, silent = true, desc = "Previous buffer" })

-- Folding
vim.keymap.set("n", "za", "za", { noremap = true, silent = true })
vim.keymap.set("n", "zA", "zA", { noremap = true, silent = true })
vim.keymap.set("n", "zc", "zc", { noremap = true, silent = true })
vim.keymap.set("n", "zC", "zC", { noremap = true, silent = true })
vim.keymap.set("n", "zo", "zo", { noremap = true, silent = true })
vim.keymap.set("n", "zO", "zO", { noremap = true, silent = true })
vim.keymap.set("n", "zv", "zv", { noremap = true, silent = true })
vim.keymap.set("n", "zx", "zx", { noremap = true, silent = true })
vim.keymap.set("n", "zX", "zX", { noremap = true, silent = true })
vim.keymap.set("n", "zm", "zm", { noremap = true, silent = true })
vim.keymap.set("n", "zM", "zM", { noremap = true, silent = true })
vim.keymap.set("n", "zr", "zr", { noremap = true, silent = true })
vim.keymap.set("n", "zR", "zR", { noremap = true, silent = true })
