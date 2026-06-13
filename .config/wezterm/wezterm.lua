local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- cursor
config.default_cursor_style = "SteadyBlock"
config.cursor_blink_rate = 0

-- window
config.enable_tab_bar = false
config.window_decorations = "NONE"

config.initial_cols = 100
config.initial_rows = 30

config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

-- scrollback
config.scrollback_lines = 4000

-- font
config.font_size = 11

config.font = wezterm.font_with_fallback({
	"JetBrainsMono Nerd Font",
})

config.harfbuzz_features = {
	"calt=0",
	"clig=0",
	"liga=0",
}

-- colorscheme
config.color_scheme = "GruvboxDark"

-- audio
config.audible_bell = "Disabled"

return config
