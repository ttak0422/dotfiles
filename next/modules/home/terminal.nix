{ ... }:
{
  xdg.configFile."ghostty/config".text = ''
    font-family = PlemolJP Console NF
    font-family = JetBrains Mono
    # Avoid Japanese unit-word and programming ligatures.
    font-feature = -calt, -liga, -dlig
    macos-option-as-alt = false

    macos-titlebar-style = hidden
    window-padding-x = 5
    window-padding-y = 5,0
    cursor-style = block
    cursor-style-blink = false

    keybind = ctrl+equal=increase_font_size:1
    # Plus requires Shift on US (=) and JIS (;) layouts.
    keybind = ctrl+shift+equal=increase_font_size:1
    keybind = ctrl+shift+semicolon=increase_font_size:1
    keybind = ctrl+minus=decrease_font_size:1
    keybind = alt+enter=toggle_fullscreen
    keybind = super+shift+f=toggle_fullscreen
  '';

  home.file."Library/KeyBindings/DefaultKeyBinding.dict".text = ''
    {
      "¥" = ("insertText:", "\\");
      "~\\" = ("insertText:", "¥");
    }
  '';
}
