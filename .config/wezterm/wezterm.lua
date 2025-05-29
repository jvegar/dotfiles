local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.font = wezterm.font("MesloLGS Nerd Font Mono")
config.font_size = 16

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


if os.getenv("OS") == "Darwin" then
  config.window_background_opacity = 0.9
  config.macos_window_background_blur = 10
else
  config.window_background_opacity = 0.875
  config.win32_system_backdrop = "Acrylic"
  config.default_domain = "WSL:Ubuntu-22.04"
  config.keys = {
    { key = "v", mods = "CTRL", action = wezterm.action{ PasteFrom = "Clipboard" } },
    { key = "r", mods = "CTRL|SHIFT", action = wezterm.action.ReloadConfiguration },
  }
  local mouse_bindings = {}
  config.mouse_bindings = mouse_bindings
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
end

return config
