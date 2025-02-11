_: {
  imports = [
    ./keymap.nix
  ];
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      input = {
        kb_layout = "jp";
      };
    };
  };
}
