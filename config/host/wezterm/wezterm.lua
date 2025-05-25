local wezterm = require 'wezterm'
local config = {}

-- Use config builder for cleaner error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- Color scheme
config.color_scheme = 'Catppuccin Mocha'

-- Font configuration
config.font = wezterm.font('JetBrains Mono', { weight = 'Medium' })
config.font_size = 14.0

-- Window configuration
config.window_background_opacity = 0.95
config.macos_window_background_blur = 20
config.window_decorations = "RESIZE"
config.window_close_confirmation = "AlwaysPrompt"

-- Tab bar
config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.show_tab_index_in_tab_bar = false

-- Cursor
config.cursor_blink_rate = 500
config.default_cursor_style = 'BlinkingBlock'

-- Scrollback
config.scrollback_lines = 10000

-- Key bindings optimized for DevPod workflow
config.keys = {
  -- DevPod shortcuts
  {
    key = 'd',
    mods = 'CMD|SHIFT',
    action = wezterm.action.SpawnCommandInNewTab {
      label = 'DevPod',
      args = { 'devpod', 'list' },
    },
  },
  
  -- Quick SSH connection (assumes you have a ssh_connect script)
  {
    key = 's',
    mods = 'CMD|SHIFT',
    action = wezterm.action.SpawnCommandInNewTab {
      label = 'SSH',
      args = { 'ssh' },
    },
  },
  
  -- Split panes
  {
    key = 'd',
    mods = 'CMD',
    action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  {
    key = 'D',
    mods = 'CMD|SHIFT',
    action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
  },
  
  -- Navigate panes
  {
    key = 'h',
    mods = 'CMD',
    action = wezterm.action.ActivatePaneDirection 'Left',
  },
  {
    key = 'j',
    mods = 'CMD',
    action = wezterm.action.ActivatePaneDirection 'Down',
  },
  {
    key = 'k',
    mods = 'CMD',
    action = wezterm.action.ActivatePaneDirection 'Up',
  },
  {
    key = 'l',
    mods = 'CMD',
    action = wezterm.action.ActivatePaneDirection 'Right',
  },
  
  -- Resize panes
  {
    key = 'LeftArrow',
    mods = 'CMD|SHIFT',
    action = wezterm.action.AdjustPaneSize { 'Left', 5 },
  },
  {
    key = 'RightArrow',
    mods = 'CMD|SHIFT',
    action = wezterm.action.AdjustPaneSize { 'Right', 5 },
  },
  {
    key = 'UpArrow',
    mods = 'CMD|SHIFT',
    action = wezterm.action.AdjustPaneSize { 'Up', 5 },
  },
  {
    key = 'DownArrow',
    mods = 'CMD|SHIFT',
    action = wezterm.action.AdjustPaneSize { 'Down', 5 },
  },
}

-- Mouse bindings
config.mouse_bindings = {
  -- Right click to paste
  {
    event = { Down = { streak = 1, button = 'Right' } },
    mods = 'NONE',
    action = wezterm.action.PasteFrom 'Clipboard',
  },
}

-- Performance
config.front_end = "WebGpu"
config.webgpu_power_preference = "HighPerformance"

return config