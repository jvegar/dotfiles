function OpenTmuxPopup()
	local cmd = "bash $HOME/.config/scripts/toggle_tmux_popup.sh"
	vim.fn.system(cmd)
end

-- Keymap for saving file in NeoVim
vim.keymap.set("n", "<leader>s", ":w<CR>", { noremap = true, silent = true })
-- Keymap for yanking to clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
-- Keymap for managing Tmux popups
vim.keymap.set("n", "<leader>p", ":lua OpenTmuxPopup()<CR>", { noremap = true, silent = true })
-- Keymap for go-to-definition
vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, { noremap = true, silent = true, desc = "Go to definition" })

-- Obsidian keymaps
vim.keymap.set(
	"n",
	"<leader>on",
	":Obsidian template note<cr>",
	{ noremap = true, silent = true, desc = "Insert template" }
)

-- Debug command for obsidian gf mapping
vim.keymap.set("n", "<leader>od", function()
  print("=== Obsidian Debug Info ===")
  print("OBSIDIAN_BASE env: " .. (vim.env.OBSIDIAN_BASE or "NOT SET"))
  print("Current file: " .. vim.fn.expand("%:p"))
  print("File type: " .. (vim.bo.filetype or "unknown"))

  local obsidian_base = vim.env.OBSIDIAN_BASE
  if obsidian_base then
    local current_file = vim.fn.expand("%:p")
    local is_in_vault = current_file:match("^" .. vim.fn.escape(obsidian_base, "/."))
    print("Is in vault: " .. (is_in_vault and "YES" or "NO"))
  end

  -- Check current line for wiki links
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2]
  print("Current line: " .. line)
  print("Cursor column: " .. col)

  -- Find wiki links
  for link, start_pos, end_pos in line:gmatch("()%[%[([^%]]+)%]%]()") do
    print(string.format("Found wiki link '%s' at positions %d-%d", link, start_pos, end_pos))
    if col >= start_pos - 2 and col <= end_pos + 2 then
      print("*** CURSOR IS ON THIS LINK ***")
    end
  end

  print("==========================")
end, { desc = "Debug obsidian gf mapping" })

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
