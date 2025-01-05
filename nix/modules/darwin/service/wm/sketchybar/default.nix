{ pkgs, ... }:
{
  services.sketchybar = {
    enable = false;
    package = pkgs.sketchybar;
    config = ''
      PLUGIN_DIR="${./plugins}"

      ##### Bar Appearance #####
      sketchybar --bar position=top \
          y_offset=0 \
          blur_radius=30 \
          height=40 \
          position=top \
          padding_left=4 \
          padding_right=4 \
          margin=0 \
          corner_radius=0

      ##### Changing Defaults #####
      default=(
        padding_left=5
        padding_right=5
        icon.font="PlemolJP Console NF:Bold:16.0"
        label.font="PlemolJP Console NF:Bold:16.0"
        icon.color=0xffffffff
        label.color=0xffffffff
        icon.padding_left=4
        icon.padding_right=4
        label.padding_left=4
        label.padding_right=4
        background.corner_radius=5
      )
      sketchybar --default "''\${default[@]}"

      sketchybar --add item chevron left \
                 --set chevron icon= label.drawing=off \
                 --add item front_app left \
                 --set front_app icon.drawing=off script="$PLUGIN_DIR/front_app.sh" \
                 --subscribe front_app front_app_switched

        sketchybar --add item battery right \
            --set battery update_freq=120 script="$PLUGIN_DIR/battery.sh" \
            --subscribe battery system_woke power_source_change

      SPACE_ICONS=("10" "9" "8" "7" "6" "5" "4" "3" "2" "1")
      for i in "''\${!SPACE_ICONS[@]}"
      do
        sid="$((10-$i))"
        space=(
          space="$sid"
          icon="''\${SPACE_ICONS[i]}"
          icon.padding_left=7
          icon.padding_right=7
          background.color=0x40ffffff
          background.corner_radius=5
          background.height=25
          label.drawing=off
          script="$PLUGIN_DIR/space.sh"
          click_script="yabai -m space --focus $sid"
        )
        sketchybar --add space space."$sid" right --set space."$sid" "''\${space[@]}"
      done

      ##### Force all scripts to run the first time (never do this in a script) #####
      sketchybar --update
    '';
  };
}
