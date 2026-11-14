{ ... }:
{
  xdg.configFile."wezterm/wezterm.lua".text =
    # lua
    ''
      local wezterm = require("wezterm")
      local config = wezterm.config_builder()
      config.font = wezterm.font_with_fallback({ "PlemolJP Console NF", "JetBrains Mono" })
      config.enable_kitty_keyboard = true
      config.enable_kitty_graphics = true
      config.enable_tab_bar = false
      config.window_decorations = "RESIZE"
      config.window_padding = { left = 5, right = 5, top = 5, bottom = 0 }
      config.audible_bell = "Disabled"
      config.default_cursor_style = "SteadyBlock"
      config.adjust_window_size_when_changing_font_size = false
      config.keys = {
        { key = "=", mods = "CTRL", action = wezterm.action.IncreaseFontSize },
        { key = "Enter", mods = "ALT", action = wezterm.action.ToggleFullScreen },
        { key = "f", mods = "SHIFT|SUPER", action = wezterm.action.ToggleFullScreen },
      }
      return config
    '';

  home.file."Library/KeyBindings/DefaultKeyBinding.dict".text = ''
    {
      "¥" = ("insertText:", "\\");
      "~\\" = ("insertText:", "¥");
    }
  '';
}
