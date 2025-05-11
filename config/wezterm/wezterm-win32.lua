local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.font = wezterm.font("MesloLGS NF Regular")
config.font_size = 12

config.enable_tab_bar = false

config.window_decorations = "RESIZE"

config.colors = {
  foreground = "#CBE0F0",
  background = "#011423",
  cursor_bg = "#47FF9C",
  cursor_border = "#47FF9C",
  cursor_fg = "#011423",
  selection_bg = "#033259",
  selection_fg = "#CBE0F0",
}

config.window_background_opacity = 0.9
config.win32_system_backdrop = 'Acrylic'

config.default_domain = 'WSL:Ubuntu-22.04'
-- This adds the ability to use ctrl+v to paste the system clipboard
config.keys = {
  { key = "v", mods = "CTRL", action = wezterm.action{ PasteFrom = "Clipboard" } },
}
return config
