-- Pull in the wezterm API
local wezterm = require("wezterm")
local act = wezterm.action

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
  { key = "t", mods = "CMD", action = act({ SpawnTab = "CurrentPaneDomain" }) },
  { key = "-", mods = "CMD", action = act.DecreaseFontSize },
  { key = "+", mods = "CMD", action = act.IncreaseFontSize },
  { key = "0", mods = "CMD", action = act.ResetFontSize },
  { key = "n", mods = "CMD", action = act.SpawnWindow },
  { key = "p", mods = "CMD", action = act.ActivateCommandPalette },
  { key = "v", mods = "CMD", action = act.PasteFrom("Clipboard") },
  { key = "c", mods = "CMD", action = act.CopyTo("Clipboard") },
  { key = "F11", mods = "NONE", action = act.ToggleFullScreen },
}

mouse_bindings = {
  {
    event = { Down = { streak = 3, button = "Left" } },
    action = act.SelectTextAtMouseCursor("SemanticZone"),
    mods = "NONE",
  },
}

-- default configuration
config = {
  hide_tab_bar_if_only_one_tab = true,
  exit_behavior = "Close",
  color_scheme = "Gruvbox dark, medium (base16)",
  window_frame = {
    font = wezterm.font("Fira Code"),
  },
  window_padding = {
    left = 3,
    right = 3,
    top = 3,
    bottom = 3,
  },
  inactive_pane_hsb = {
    saturation = 0.9,
    brightness = 0.7,
  },
  use_dead_keys = false,
  scrollback_lines = 3500,
  font = wezterm.font_with_fallback({
    { family = "Victor Mono" },
    { family = "JetBrains Mono" },
    { family = "Iosevka" },
  }),
  font_size = 16.0,
  launch_menu = launch_menu,
  default_cursor_style = "BlinkingBar",
  disable_default_key_bindings = true,
  keys = keys,
  mouse_bindings = mouse_bindings,
}

-- and finally, return the configuration to wezterm
return config