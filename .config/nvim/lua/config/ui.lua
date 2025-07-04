local augroup = vim.api.nvim_create_augroup("custom-ui", { clear = true })

vim.api.nvim_create_autocmd("ColorScheme", {
  group = augroup,
  pattern = "*",
  callback = function()
    local highlights = {
      FloatBorder = { bg = "none" },
      NormalFloat = { bg = "none" },
      WinSeparator = { bg = "none" },
      TelescopeNormal = { bg = "none" },
      TelescopeBorder = { bg = "none" },
      TelescopePromptNormal = { bg = "none" },
      TelescopePromptBorder = { bg = "none" },
      TelescopeResultsNormal = { bg = "none" },
      TelescopeResultsBorder = { bg = "none" },
      TelescopePreviewNormal = { bg = "none" },
      TelescopePreviewBorder = { bg = "none" },
      FoldColumn = { bg = "none" },
      SignColumn = { bg = "none" },
    }

    for group, settings in pairs(highlights) do
      vim.api.nvim_set_hl(0, group, settings)
    end
  end,
})
