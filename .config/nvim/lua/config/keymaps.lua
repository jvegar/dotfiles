function OpenTmuxPopup()
  local cmd = 'bash $HOME/.config/scripts/toggle_tmux_popup.sh'
  vim.fn.system(cmd)
end

vim.keymap.set('n', '<leader>s', ':w<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>p', ':lua OpenTmuxPopup()<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>gd', vim.lsp.buf.definition, { noremap = true, silent = true, desc = "Go to definition" })

-- Folding
vim.keymap.set('n', 'za', 'za', { noremap = true, silent = true })
vim.keymap.set('n', 'zA', 'zA', { noremap = true, silent = true })
vim.keymap.set('n', 'zc', 'zc', { noremap = true, silent = true })
vim.keymap.set('n', 'zC', 'zC', { noremap = true, silent = true })
vim.keymap.set('n', 'zo', 'zo', { noremap = true, silent = true })
vim.keymap.set('n', 'zO', 'zO', { noremap = true, silent = true })
vim.keymap.set('n', 'zv', 'zv', { noremap = true, silent = true })
vim.keymap.set('n', 'zx', 'zx', { noremap = true, silent = true })
vim.keymap.set('n', 'zX', 'zX', { noremap = true, silent = true })
vim.keymap.set('n', 'zm', 'zm', { noremap = true, silent = true })
vim.keymap.set('n', 'zM', 'zM', { noremap = true, silent = true })
vim.keymap.set('n', 'zr', 'zr', { noremap = true, silent = true })
vim.keymap.set('n', 'zR', 'zR', { noremap = true, silent = true })
