local wezterm = require("wezterm")
local colors = require("colorscheme")

return {
  term = "xterm-256color",

  font = wezterm.font_with_fallback({
    { family = "JetBrainsMono Nerd Font", weight = "Regular" },
  }),
  font_size = 20.0,
  line_height = 1.00,

  harfbuzz_features = { "calt=0", "clig=0", "liga=0" },

  enable_tab_bar = false,
  window_close_confirmation = "NeverPrompt",
  adjust_window_size_when_changing_font_size = false,
  window_background_opacity = 1.00,

  window_padding = {
    left = 10,
    right = 10,
    top = 10,
    bottom = 10,
  },

  default_cursor_style = "SteadyBlock",
  cursor_blink_rate = 0,
  hide_mouse_cursor_when_typing = false,
  scrollback_lines = 10000,

  colors = colors,
}
