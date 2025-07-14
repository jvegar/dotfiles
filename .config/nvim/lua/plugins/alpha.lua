return {
  "goolord/alpha-nvim",
  enabled = true,
  dependencies = { "nvim-tree/nvim-web-devicons", "nvim-telescope/telescope.nvim" },
  config = function()
    local alpha = require("alpha")
    local startify = require("alpha.themes.startify")

    -- Set icon provider
    startify.file_icons.provider = "devicons"

    -- ASCII art header
    local header_val = {
      "     ██╗██╗   ██╗███████╗ ██████╗  █████╗ ██████╗ ",
      "     ██║██║   ██║██╔════╝██╔════╝ ██╔══██╗██╔══██╗",
      "     ██║██║   ██║█████╗  ██║  ███╗███████║██████╔╝",
      "██   ██║╚██╗ ██╔╝██╔══╝  ██║   ██║██╔══██║██╔══██╗",
      "╚█████╔╝ ╚████╔╝ ███████╗╚██████╔╝██║  ██║██║  ██║",
      " ╚════╝   ╚═══╝  ╚══════╝ ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝",
    }

    local header = {
      type = "text",
      val = header_val,
      opts = {
        position = "center",
        hl = "Type",
      },
    }

    -- Define the buttons
    local buttons = {
        type = "group",
        val = {
            startify.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
            startify.button("f", "  Find file", ":Telescope find_files <CR>"),
            startify.button("r", "  Recent files", ":Telescope oldfiles <CR>"),
            startify.button("g", "  Find text", ":Telescope live_grep <CR>"),
            startify.button("c", "  Config", ":e $MYVIMRC <CR>"),
            startify.button("q", "  Quit", ":qa<CR>"),
        },
        opts = {
            spacing = 1,
        },
    }

    -- Define the new layout, replacing the default one
    startify.config.layout = {
        { type = "padding", val = 2 },
        header,
        { type = "padding", val = 2 },
        buttons,
        { type = "padding", val = 2 },
        startify.mru(0, { hl = "Number", hl_shortcut = "Number" }),
        { type = "padding", val = 1 },
        startify.footer,
    }

    alpha.setup(startify.config)
  end,
}
