local wezterm = require("wezterm")

local config = wezterm.config_builder()

-- Reduce resource usage
config.animation_fps = 30 -- Lower animation FPS
config.cursor_blink_ease_in = "Linear"
config.cursor_blink_ease_out = "Linear"
config.cursor_blink_rate = 800 -- Slower cursor blink

-- Scrollback buffer optimization
config.scrollback_lines = 10000 -- Reduce scrollback from default 3500
config.enable_scroll_bar = false -- Disable scroll bar for performance

config.font_rules = {}
config.font_shaper = "Harfbuzz" -- Use Harfbuzz for better performance
config.harfbuzz_features = { "kern", "liga", "clig" } -- Enable only essential features
config.freetype_load_flags = "NO_HINTING" -- Faster font rendering

-- Appearance
config.hide_tab_bar_if_only_one_tab = true
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

-- OS specific configuration
-- MacOS
if wezterm.target_triple == "x86_64-apple-darwin" then
	-- Font settings with performance optimizations
	config.font = wezterm.font_with_fallback({
		"CaskaydiaCove Nerd Font",
		"MesloLGS Nerd Font Mono",
		"Symbols Nerd Font",
	})
	config.front_end = "OpenGL"
	config.window_decorations = "MACOS_FORCE_DISABLE_SHADOW | RESIZE"
	config.font_size = 19
	config.window_background_opacity = 0.9
	config.macos_window_background_blur = 10

	-- Explicit fullscreen toggle
	config.keys = {
		{ key = "f", mods = "CMD|CTRL", action = wezterm.action.ToggleFullScreen },
		{ key = "r", mods = "CMD|SHIFT", action = wezterm.action.ReloadConfiguration },
	}
-- Windows
elseif wezterm.target_triple == "x86_64-pc-windows-msvc" then
	-- WSL-specific performance optimizations
	config.prefer_egl = false -- Disable EGL for WSL compatibility
	config.webgpu_power_preference = "HighPerformance" -- Use high performance GPU
	config.front_end = "WebGpu" -- Use WebGPU for better performance on Windows
	config.window_decorations = "RESIZE"
	config.font_size = 12
	config.window_background_opacity = 0.9
	-- config.win32_system_backdrop = "Acrylic"
	config.default_domain = "WSL:archlinux"

	-- WSL-specific optimizations
	config.enable_kitty_keyboard = false -- Disable for compatibility
	config.use_dead_keys = false -- Disable dead keys for performance
	config.unicode_version = 14 -- Use newer Unicode version for better compatibility
	config.allow_win32_input_mode = true -- Enable Windows input mode
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
					window:perform_action(wezterm.action.CopyTo("ClipBoardAndPrimarySelection"), pane)
					window:perform_action(wezterm.action.ClearSelection, pane)
				else
					window:perform_action(wezterm.action({ PasteFrom = "ClipBoard" }), pane)
				end
			end),
		},
	}
-- Linux
elseif wezterm.target_triple == "x86_64-unknown-linux-gnu" then
	config.bold_brightens_ansi_colors = true
	config.font = wezterm.font_with_fallback({
		{ family = "JetBrains Mono", weight = "Regular" },
	})
	config.font_rules = {
		{
			intensity = "Bold",
			font = wezterm.font("JetBrains Mono", { weight = "ExtraBold" }),
		},
	}
	config.font_size = 10.0
	config.line_height = 1.0
	config.front_end = "WebGpu"
	config.window_padding = {
		left = 10,
		right = 10,
		top = 10,
		bottom = 10,
	}
end

config.debug_key_events = true

return config
