local wezterm = require("wezterm")

local config = wezterm.config_builder()
local mux = wezterm.mux

-- Font settings
config.font = wezterm.font("MesloLGS Nerd Font Mono")
config.font_size = 14

-- Appearance
config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = true
config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

-- Colors
config.colors = {
  foreground = "#CBE0F0",
  background = "#011423",
  cursor_bg = "#47FF9C",
  cursor_border = "#47FF9C",
  cursor_fg = "#011423",
  selection_bg = "#033259",
  selection_fg = "#CBE0F0",
}

-- OS specific configuration
if os.getenv("OS") == "Darwin" then
  config.window_background_opacity = 0.9
  config.macos_window_background_blur = 10
else
  config.window_background_opacity = 0.8
  config.win32_system_backdrop = "Acrylic"
  config.default_domain = "WSL:Ubuntu-22.04"
  config.keys = {
    { key = "v", mods = "CTRL", action = wezterm.action{ PasteFrom = "Clipboard" }, },
    { key = "r", mods = "CTRL|SHIFT", action = wezterm.action.ReloadConfiguration, },
    { key = "n", mods = "CTRL|SHIFT", action = wezterm.action.ToggleFullScreen, },
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

-- Custom setting on startup
wezterm.on('gui-startup', function(cmd)
  local tab, pane, window = mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)

-- Zero bottom padding when resizing window
function readjust_font_size(window, pane)
  local window_dims = window:get_dimensions()
  local pane_dims = pane:get_dimensions()

  local config_overrides = {}
  local initial_font_size = 12
  config_overrides.font_size = initial_font_size

  local max_iterations = 5
  local iteration_count = 0
  local tolerance = 3

  -- Calculate the initial difference between window and pane heights
  local current_diff = window_dims.pixel_height - pane_dims.pixel_height
  local min_diff = math.abs(current_diff)
  local best_font_size = initial_font_size

  -- Loop to adjust font size until the difference is within tolerance or max iterations reached
  while current_diff > tolerance and iteration_count < max_iterations do

    -- Increment the font size slightly
    config_overrides.font_size = config_overrides.font_size + 0.5
    window:set_config_overrides(config_overrides)

    -- Update dimensions after changing font size
    window_dims = window:get_dimensions()
    pane_dims = pane:get_dimensions()
    current_diff = window_dims.pixel_height - pane_dims.pixel_height

    -- Check if the current difference is the smallest seen so far
    local abs_diff = math.abs(current_diff)
    if abs_diff < min_diff then
      min_diff = abs_diff
      best_font_size = config_overrides.font_size
    end

    iteration_count = iteration_count + 1
  end

  -- If no acceptable difference was found, set the font size to the best one encountered
  if current_diff > tolerance then
    config_overrides.font_size = best_font_size
    window:set_config_overrides(config_overrides)
  end
end

wezterm.on("window-resized", function(window, pane)
  readjust_font_size(window, pane)
end)

return config
