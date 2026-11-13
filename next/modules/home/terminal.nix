{ ... }:
{
  xdg.configFile."wezterm/wezterm.lua".source = ../../assets/wezterm.lua;
  home.file."Library/KeyBindings/DefaultKeyBinding.dict".source =
    ../../assets/DefaultKeyBinding.dict;
}
