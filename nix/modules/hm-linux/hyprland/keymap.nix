{ pkgs, ... }:
{
  home.packages = with pkgs; [
    brightnessctl
    pamixer
  ];
  wayland.windowManager.hyprland.settings = {
    "$mainMod" = "SUPER";
    "$subMod" = "ALT";
    "$term" = "wezterm";
    bind = [
      "$mainMod, Return, exec, $term"
      "$mainMod, SPACE, exec, rofi -show drun"
      "$mainMod, l, exec, hyprlock"

      "$subMod, h, movefocus, l"
      "$subMod, j, movefocus, d"
      "$subMod, k, movefocus, u"
      "$subMod, l, movefocus, r"
      "$subMod SHIFT, h, swapwindow, l"
      "$subMod SHIFT, j, swapwindow, d"
      "$subMod SHIFT, k, swapwindow, u"
      "$subMod SHIFT, l, swapwindow, r"
      "$subMod, Tab, cyclenext"
      "$subMod SHIFT, Tab, cyclenext, prev"
      "$subMod, z, fullscreen"
      "$subMod, f, togglefloating"
      "$subMod, q, killactive"

      "$mainMod, 1, workspace, 1"
      "$mainMod, 2, workspace, 2"
      "$mainMod, 3, workspace, 3"
      "$mainMod, 4, workspace, 4"
      "$mainMod, 5, workspace, 5"
      "$mainMod, 6, workspace, 6"
      "$mainMod, 7, workspace, 7"
      "$mainMod, 8, workspace, 8"
      "$mainMod, 9, workspace, 9"
      "$mainMod, 0, workspace, 10"

      "$mainMod SHIFT, 1, movetoworkspace, 1"
      "$mainMod SHIFT, 2, movetoworkspace, 2"
      "$mainMod SHIFT, 3, movetoworkspace, 3"
      "$mainMod SHIFT, 4, movetoworkspace, 4"
      "$mainMod SHIFT, 5, movetoworkspace, 5"
      "$mainMod SHIFT, 6, movetoworkspace, 6"
      "$mainMod SHIFT, 7, movetoworkspace, 7"
      "$mainMod SHIFT, 8, movetoworkspace, 8"
      "$mainMod SHIFT, 9, movetoworkspace, 9"
      "$mainMod SHIFT, 0, movetoworkspace, 10"

      "CTRL, up, overview:toggle"
      "CTRL, down, overview:toggle"
    ];

    binde = [
      "$subMod, a, resizeactive, -20 0"
      "$subMod, s, resizeactive, 0 20"
      "$subMod, w, resizeactive, 0 -20"
      "$subMod, d, resizeactive, 20 0"
    ];

    bindm = [
      "$subMod, mouse:272, movewindow"
      "$subMod, mouse:273, resizewindow"
    ];

    bindl = [
      ", XF86AudioMute, exec, pamixer -t"
    ];

    bindel = [
      ", XF86AudioRaiseVolume, exec, pamixer -i 10"
      ", XF86AudioLowerVolume, exec, pamixer -d 10"
      ", XF86MonBrightnessUp, exec, brightnessctl set +10%"
      ", XF86MonBrightnessDown, exec, brightnessctl set 10%-"
    ];
  };
}
