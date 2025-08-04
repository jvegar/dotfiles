local wezterm = require("wezterm")

local config = wezterm.config_builder()
local mux = wezterm.mux
local act = wezterm.action

-- Font settings
config.font = wezterm.font_with_fallback({
	"CaskaydiaCove Nerd Font",
	"MesloLGS Nerd Font Mono",
	"Symbols Nerd Font",
})

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
--config.colors = {
--	foreground = "#CBE0F0",
--	background = "#011423",
--	cursor_bg = "#47FF9C",
--	cursor_border = "#47FF9C",
--	cursor_fg = "#011423",
--	selection_bg = "#033259",
--	selection_fg = "#CBE0F0",
--}

-- OS specific configuration
if wezterm.target_triple == "x86_64-apple-darwin" then
	config.font_size = 19
	config.window_background_opacity = 0.9
	config.macos_window_background_blur = 10
else
	config.font_size = 12
	config.window_background_opacity = 0.825
	config.win32_system_backdrop = "Acrylic"
	config.default_domain = "WSL:archlinux"
	config.keys = {
		{ key = "v", mods = "CTRL", action = wezterm.action({ PasteFrom = "Clipboard" }) },
		{ key = "r", mods = "CTRL|SHIFT", action = wezterm.action.ReloadConfiguration },
		{ key = "n", mods = "CTRL|SHIFT", action = wezterm.action.ToggleFullScreen },
	}
	local mouse_bindings = {}
	config.mouse_bindings = mouse_bindings
	mouse_bindings = {
		{
			event = { Down = { streak = 3, button = "Left" } },
			action = wezterm.action.SelectTextAtMouseCursor("SemanticZone"),
			mods = "NONE",
		},
		{
			event = { Down = { streak = 1, button = "Right" } },
			mods = "NONE",
			action = wezterm.action_callback(function(window, pane)
				local has_selection = window:get_selection_text_for_pane(pane) ~= ""
				if has_selection then
					window:perform_action(act.CopyTo("ClipBoardAndPrimarySelection"), pane)
					window:perform_action(act.ClearSelection, pane)
				else
					window:perform_action(act({ PasteFrom = "ClipBoard" }), pane)
				end
			end),
		},
	}
end

-- Custom setting on startup
wezterm.on("gui-startup", function(cmd)
	local _, _, window = mux.spawn_window(cmd or {})
	window:gui_window():toggle_fullscreen()
end)

return config
