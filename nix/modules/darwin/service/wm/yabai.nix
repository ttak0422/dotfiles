_: {
  services.yabai = {
    enable = true;
    enableScriptingAddition = false;
    extraConfig = ''
      yabai -m rule --add app='Finder' manage=off
      yabai -m rule --add app='AnyConnect' manage=off
      yabai -m rule --add app='WezTerm' manage=off
      yabai -m config layout            bsp
      yabai -m config mouse_modifier    alt
      yabai -m config mouse_action1     move
      yabai -m config mouse_action2     resize
      yabai -m config mouse_drop_action swap
      yabai -m config top_padding       8
      yabai -m config bottom_padding    8
      yabai -m config left_padding      8
      yabai -m config right_padding     8
      yabai -m space --gap abs:12
    '';
  };
}
