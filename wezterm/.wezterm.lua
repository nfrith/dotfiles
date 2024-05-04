-- Pull in the wezterm API

local wezterm = require 'wezterm'
-- This will hold the configuration.
local config = wezterm.config_builder()

config.front_end = 'OpenGL'
config.color_scheme = 'Batman'
config.font = wezterm.font("JetBrainsMono NF")
config.font_size = 12
config.default_domain = 'WSL:Ubuntu'
config.keys = {
  {
    key = 'r',
    mods = 'CMD|SHIFT',
    action = wezterm.action.ReloadConfiguration,
  },
}

-- and finally, return the configuration to wezterm
return config
