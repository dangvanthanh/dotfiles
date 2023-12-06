-- Wezterm configuration file
local wezterm = require("wezterm")
local act = wezterm.action

local fish_path = "/opt/homebrew/bin/fish"

local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- Settings
config.default_prog = { fish_path, "-l" }

config.color_scheme = "Gruvbox dark, medium (base16)"
config.font = wezterm.font_with_fallback({
  { family = "Victor Mono" },
  { family = "Iosevka" },
})
config.font_size = 16.0
config.default_cursor_style = "BlinkingBar"
config.use_dead_keys = false
config.scrollback_lines = 3500
config.hide_tab_bar_if_only_one_tab = true
config.exit_behavior = "Close"
config.inactive_pane_hsb = {
  saturation = 0.9,
  brightness = 0.7,
}
config.window_frame = {
  font = wezterm.font("Victor Mono"),
}
config.window_padding = {
  left = 3,
  right = 3,
  top = 3,
  bottom = 3,
}
config.disable_default_key_bindings = true
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }
config.keys = {
  -- Send C-a when pressing C-a twice
  { key = "a", mods = "LEADER|CTRL", action = act.SendKey({ key = "a", mods = "CTRL" }) },
  { key = "t", mods = "CMD", action = act({ SpawnTab = "CurrentPaneDomain" }) },
  { key = "w", mods = "CMD", action = act.CloseCurrentPane({ confirm = false }) },
  { key = "n", mods = "CMD", action = act.SpawnWindow },
  { key = "p", mods = "CMD", action = act.ActivateCommandPalette },
  { key = "v", mods = "CMD", action = act.PasteFrom("Clipboard") },
  { key = "c", mods = "CMD", action = act.CopyTo("Clipboard") },
  -- Font key bindings
  { key = "-", mods = "CMD", action = act.DecreaseFontSize },
  { key = "+", mods = "CMD", action = act.IncreaseFontSize },
  { key = "0", mods = "CMD", action = act.ResetFontSize },
  -- Pane key bidings
  { key = "|", mods = "LEADER|SHIFT", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
  { key = "_", mods = "LEADER|SHIFT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
  { key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
  { key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
  { key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
  { key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },
  { key = "h", mods = "LEADER|CTRL", action = act.AdjustPaneSize({ "Left", 10 }) },
  { key = "j", mods = "LEADER|CTRL", action = act.AdjustPaneSize({ "Down", 10 }) },
  { key = "k", mods = "LEADER|CTRL", action = act.AdjustPaneSize({ "Up", 10 }) },
  { key = "l", mods = "LEADER|CTRL", action = act.AdjustPaneSize({ "Right", 10 }) },
}

-- and finally, return the configuration to wezterm
return config