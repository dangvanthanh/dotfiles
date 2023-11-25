-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This table will hold the configuration.
local config = {}
local keys = {}
local mouse_bindings = {}
local launch_menu = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

keys = {
  { key = "T", mods = "CMD", action = wezterm.action({ SpawnTab = "CurrentPaneDomain" }) },
  { key = "-", mods = "CMD", action = wezterm.action.DecreaseFontSize },
  { key = "+", mods = "CMD", action = wezterm.action.IncreaseFontSize },
  { key = "0", mods = "CMD", action = wezterm.action.ResetFontSize },
  { key = "N", mods = "CMD", action = wezterm.action.SpawnWindow },
  { key = "P", mods = "CMD", action = wezterm.action.ActivateCommandPalette },
  { key = "V", mods = "CMD", action = wezterm.action.PasteFrom("Clipboard") },
  { key = "C", mods = "CMD", action = wezterm.action.CopyTo("Clipboard") },
  { key = "F11", mods = "NONE", action = wezterm.action.ToggleFullScreen },
}

mouse_bindings = {
  {
    event = { Down = { streak = 3, button = "Left" } },
    action = wezterm.action.SelectTextAtMouseCursor("SemanticZone"),
    mods = "NONE",
  },
}

-- default configuration
config.hide_tab_bar_if_only_one_tab = true
config.exit_behavior = "Close"
config.color_scheme = "Gruvbox dark, medium (base16)"
config.window_frame = {
  font = wezterm.font("Victor Mono"),
}
config.window_padding = {
  left = 3,
  right = 3,
  top = 3,
  bottom = 3,
}
config.inactive_pane_hsb = {
  saturation = 0.9,
  brightness = 0.7,
}
config.use_dead_keys = false
config.scrollback_lines = 3500
config.font = wezterm.font_with_fallback({
  { family = "Victor Mono" },
  { family = "JetBrains Mono" },
  { family = "Iosevka" },
})
config.font_size = 16.0
config.launch_menu = launch_menu
config.default_cursor_style = "BlinkingBar"
config.disable_default_key_bindings = true
config.keys = keys
config.mouse_bindings = mouse_bindings

-- and finally, return the configuration to wezterm
return config