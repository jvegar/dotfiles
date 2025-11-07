vim.keymap.set("n", "<leader>x", function()
  local linenr = vim.fn.line(".")
  local line = vim.fn.getline(linenr)
  if string.match(line, "%[ %]") then
    local new_line = string.gsub(line, "%[ %]", "[x]")
    vim.fn.setline(linenr, new_line)
  elseif string.match(line, "%[x%]") then
    local new_line = string.gsub(line, "%[x%]", "[ ]")
    vim.fn.setline(linenr, new_line)
  end
end, { buffer = true, desc = "Toggle checkbox" })