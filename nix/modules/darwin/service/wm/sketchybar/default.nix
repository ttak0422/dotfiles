{ pkgs, ... }:
{
  services.sketchybar = {
    enable = true;
    package = pkgs.sketchybar;
    config = ''
      PLUGIN_DIR="${./plugins}"

      ##### Bar Appearance #####
      sketchybar --bar position=top height=40 blur_radius=30 color=0x40000000

      ##### Changing Defaults #####
      default=(
        padding_left=5
        padding_right=5
        icon.font="PlemolJP Console NF:Bold:17.0"
        label.font="PlemolJP Console NF:Bold:14.0"
        icon.color=0xffffffff
        label.color=0xffffffff
        icon.padding_left=4
        icon.padding_right=4
        label.padding_left=4
        label.padding_right=4
      )
      sketchybar --default "''\${default[@]}"

      ##### Adding Mission Control Space Indicators #####
      SPACE_ICONS=("1" "2" "3" "4" "5" "6" "7" "8" "9" "10")
      for i in "''\${!SPACE_ICONS[@]}"
      do
        sid="$(($i+1))"
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
        sketchybar --add space space."$sid" left --set space."$sid" "''\${space[@]}"
      done

      ##### Adding Left Items #####
      sketchybar --add item chevron left \
                 --set chevron icon= label.drawing=off \
                 --add item front_app left \
                 --set front_app icon.drawing=off script="$PLUGIN_DIR/front_app.sh" \
                 --subscribe front_app front_app_switched

      ##### Adding Right Items #####
      sketchybar --add item clock right \
                 --set clock update_freq=10 script="$PLUGIN_DIR/clock.sh" \
                 --add item battery right \
                 --set battery update_freq=120 script="$PLUGIN_DIR/battery.sh" \
                 --subscribe battery system_woke power_source_change

      ##### Force all scripts to run the first time (never do this in a script) #####
      sketchybar --update
    '';
  };
}
