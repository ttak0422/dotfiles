_:
let
  mod = "alt";
  resizeAmount = 100;
in
{
  services.skhd = {
    enable = true;
    skhdConfig = ''
      ${mod} - h : yabai -m window --focus west
      ${mod} - j : yabai -m window --focus south
      ${mod} - k : yabai -m window --focus north
      ${mod} - l : yabai -m window --focus east

      shift + ${mod} - h : yabai -m window --swap west
      shift + ${mod} - j : yabai -m window --swap south
      shift + ${mod} - k : yabai -m window --swap north
      shift + ${mod} - l : yabai -m window --swap east

      shift + ${mod} - 1 : yabai -m display --focus 1
      shift + ${mod} - 2 : yabai -m display --focus 2
      shift + ${mod} - 3 : yabai -m display --focus 3
      shift + ${mod} - 4 : yabai -m display --focus 4

      ${mod} - w : yabai -m window --resize top:0:-${toString resizeAmount}
      ${mod} - a : yabai -m window --resize left:-${toString resizeAmount}:0
      ${mod} - s : yabai -m window --resize bottom:0:${toString resizeAmount}
      ${mod} - d : yabai -m window --resize right:${toString resizeAmount}:0

      shift + ${mod} - w : yabai -m window --resize top:0:${toString resizeAmount}
      shift + ${mod} - a : yabai -m window --resize left:${toString resizeAmount}:0
      shift + ${mod} - s : yabai -m window --resize bottom:0:-${toString resizeAmount}
      shift + ${mod} - d : yabai -m window --resize right:-${toString resizeAmount}:0

      ${mod} - z : yabai -m window --toggle zoom-fullscreen
      ${mod} - f : yabai -m window --toggle float && yabai -m window --grid 10:10:1:1:8:8
      ${mod} - left : yabai -m window --toggle float && yabai -m window --grid 100:200:1:1:198:98
      ${mod} - right : yabai -m window --toggle float && yabai -m window --grid 10:10:5:0:5:10
      ${mod} - v :/Applications/Neovide.app/Contents/MacOS/neovide --frame=none --multigrid
    '';
  };
}
