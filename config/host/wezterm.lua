-- ~/.config/wezterm/wezterm.lua
local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- Color scheme - similar to your dark theme
config.color_scheme = 'Tokyo Night'  -- or try 'Catppuccin Mocha', 'nord', 'OneDark'

-- Window appearance
config.window_background_opacity = 0.85  -- Adjust for transparency level
config.macos_window_background_blur = 20  -- macOS blur effect
config.window_decorations = "RESIZE"  -- Clean title bar like in your image

-- Font configuration
config.font = wezterm.font('JetBrains Mono', { weight = 'Medium' })  -- or try 'Fira Code', 'SF Mono'
config.font_size = 13.0
config.line_height = 1.2

-- Window padding - gives that clean look
config.window_padding = {
  left = 20,
  right = 20,
  top = 20,
  bottom = 20,
}

-- Tab bar styling - ENABLED with custom styling
config.enable_tab_bar = true
config.use_fancy_tab_bar = false  -- Use retro style for better customization
config.tab_bar_at_bottom = false  -- Tabs at top
config.hide_tab_bar_if_only_one_tab = false  -- Always show tab bar
config.tab_max_width = 32

-- Tab bar colors
config.colors = {
  tab_bar = {
    -- The color of the strip that goes along the top of the window
    background = '#1a1a1a',
    
    -- The active tab is the one that has focus in the window
    active_tab = {
      bg_color = '#2b2042',
      fg_color = '#c0c0c0',
      intensity = 'Normal',
      underline = 'None',
      italic = false,
      strikethrough = false,
    },

    -- Inactive tabs are the ones that do not have focus
    inactive_tab = {
      bg_color = '#1b1032',
      fg_color = '#808080',
      intensity = 'Normal',
      underline = 'None',
      italic = false,
      strikethrough = false,
    },

    -- When hovering over inactive tabs
    inactive_tab_hover = {
      bg_color = '#3b3052',
      fg_color = '#909090',
      intensity = 'Normal',
      underline = 'None',
      italic = false,
      strikethrough = false,
    },

    -- The new tab button that let you create new tabs
    new_tab = {
      bg_color = '#1b1032',
      fg_color = '#808080',
    },

    -- When hovering over the new tab button
    new_tab_hover = {
      bg_color = '#3b3052',
      fg_color = '#909090',
    },
  },
}

-- Window sizing and behavior
config.initial_cols = 120
config.initial_rows = 30
config.window_close_confirmation = 'NeverPrompt'

-- Additional visual tweaks
config.enable_scroll_bar = false
config.cursor_blink_rate = 500
config.default_cursor_style = 'BlinkingBlock'

-- Custom tab title formatting with active tab indicators
wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
  local edge_background = '#1a1a1a'
  local background = '#1b1032'
  local foreground = '#808080'
  
  if tab.is_active then
    background = '#2b2042'
    foreground = '#c0c0c0'
  elseif hover then
    background = '#3b3052'
    foreground = '#909090'
  end

  local edge_foreground = background

  -- Get the title (try tab title first, then active pane title)
  local title = tab.tab_title
  if title and #title > 0 then
    -- Tab title was explicitly set
  else
    -- Use the active pane's title
    title = tab.active_pane.title
  end

  -- Ensure the title fits in the available space
  title = wezterm.truncate_right(title, max_width - 4)

  -- Add indicators for active tab
  local left_arrow = '▎'
  local right_arrow = ' '
  
  if tab.is_active then
    left_arrow = '▎'  -- Active indicator
    title = ' ● ' .. title .. ' '  -- Active dot
  else
    title = '   ' .. title .. ' '  -- Regular spacing
  end

  return {
    { Background = { Color = edge_background } },
    { Foreground = { Color = edge_foreground } },
    { Text = left_arrow },
    { Background = { Color = background } },
    { Foreground = { Color = foreground } },
    { Text = title },
    { Background = { Color = edge_background } },
    { Foreground = { Color = edge_foreground } },
    { Text = right_arrow },
  }
end)

return config
