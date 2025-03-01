_: {
  # programs.wezterm = {
  #   enable = true;
  #   extraConfig = builtins.readFile ./wezterm.lua;
  # };
  home.file.".config/wezterm/wezterm.lua".text = builtins.readFile ./wezterm.lua;
}
