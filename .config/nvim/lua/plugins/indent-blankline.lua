return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  opts = {
    indent = {
      char = "│",
      highlight = { "IndentBlanklineCharLight" },
    },
  },
  config = function(_, opts)
    local hooks = require("ibl.hooks")
    -- Create the highlight group using the hook
    hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
      vim.api.nvim_set_hl(0, "IndentBlanklineCharLight", { fg = "#444444" })
    end)
    -- Call the plugin's setup function with the options
    require("ibl").setup(opts)
  end,
}
