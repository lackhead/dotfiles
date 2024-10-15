local wezterm = require 'wezterm'
local config = {}

-- General 
config.automatically_reload_config = true
config.window_close_confirmation = "NeverPrompt"

-- Fonts
config.color_scheme = 'Catppuccin Mocha'
config.font_size = 16.0
config.font = wezterm.font('JetBrains Mono')
config.adjust_window_size_when_changing_font_size = true

-- Window style
config.macos_window_background_blur = 45
config.window_background_opacity = 0.9
config.window_decorations = "TITLE | RESIZE"
config.window_padding = { left = 15, right = 15, top = 10, bottom = 10 }
config.hide_tab_bar_if_only_one_tab = true
config.enable_tab_bar = true
config.initial_cols = 100
config.initial_rows = 30

-- key/mouse bindings
config.keys = {
	{
		key = 'f',
		mods = 'CTRL',
		action = wezterm.action.ToggleFullScreen,
	},
	{
		key = '\'',
		mods = 'CTRL',
		action = wezterm.action.ClearScrollback 'ScrollbackAndViewport',
	},
}
config.mouse_bindings = {
	{
		-- Ctrl-click will open the link under the mouse cursor
		event = { Up = { streak = 1, button = 'Left' } },
		mods = 'CTRL',
		action = wezterm.action.OpenLinkAtMouseCursor,
	},
}

return config
