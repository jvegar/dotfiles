require("config.keymaps.go-definition")

function OpenTmuxPoup()
  local cmd = 'bash $HOME/.config/scripts/toggle_tmux_popup.sh'
  vim.fn.system(cmd)
end

vim.keymap.set('n', '<leader>s', ':w<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>p', ':lua OpenTmuxPoup()<CR>', { noremap = true, silent = true })
