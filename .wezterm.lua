local wezterm = require 'wezterm'
local config = {}

-- Window style
config.color_scheme = 'Catppuccin Mocha'
config.enable_tab_bar = true
config.font_size = 16.0
config.font = wezterm.font('JetBrains Mono')

-- Window characteristics 
config.macos_window_background_blur = 40
config.window_background_opacity = 0.8
config.window_decorations = 'RESIZE'

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
mouse_bindings = {
	{
		-- Ctrl-click will open the link under the mouse cursor
		event = { Up = { streak = 1, button = 'Left' } },
		mods = 'CTRL',
		action = wezterm.action.OpenLinkAtMouseCursor,
	},
}

return config
