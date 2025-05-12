local wezterm = require("wezterm")

local config = wezterm.config_builder()

local mouse_bindings = {}

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

-- Sets WSL2 Ubuntu-22.04 as th default when opening Wezterm
config.default_domain = 'WSL:Ubuntu-22.04'
-- This adds the ability to use ctrl+v to paste the system clipboard
config.keys = {
  { key = "v", mods = "CTRL", action = wezterm.action{ PasteFrom = "Clipboard" } },
}
config.mouse_bindings = mouse_bindings

-- There are mouse bindings to mimic Windows Terminal and let you copy
-- To copy just highlight something and right click
mouse_bindings = {
  {
    event = { Down = { streak = 3, button = 'Left' } },
    action = wezterm.action.SelectTextAtMouseCursor 'SemanticZone',
    mods = 'NONE',
  },
  {
    event = { Down = { streak = 1, button = 'Right' } },
    mods = 'NONE',
    action = wezterm.action_callback(function(window, pane)
      local has_selection = window:get_selection_text_for_pane(pane) ~= ''
      if has_selection then
        window:perform_action(act.CopyTo('ClipBoardAndPrimarySelection'), pane)
        window:perform_action(act.ClearSelection, pane)
      else
        window:perform_action(act({ PasteFrom = 'ClipBoard' }), pane)
      end
    end),
  },
}

return config
