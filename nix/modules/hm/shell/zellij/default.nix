{ pkgs, ... }:
{
  programs.zellij.enable = true;
  home = {
    file.".config/zellij/config.kdl".text = builtins.readFile ./config.kdl;
    file.".config/zellij/layouts/default.kdl".text = ''
      layout {
        default_tab_template {
            children
            pane size=1 borderless=true {
                plugin location="file:${pkgs.zjstatus}/bin/zjstatus.wasm" {
                    format_left   "{tabs}"
                    format_center ""
                    format_right  "{mode}#[fg=#767b82,bg=#2a2a2e,bold]({session})"
                    format_space  "[fg=#b5d2a9,bg=#2a2a2e]"
                    first_start "true"

                    border_enabled  "false"
                    border_char     "─"
                    border_format   "#[fg=#6C7086]{char}"
                    border_position "top"

                    hide_frame_for_single_pane "false"

                    mode_tmux          "#[fg=#d3c785,bg=#2a2a2e,bold,italic] Zellij "
                    mode_normal        "#[fg=#767b82,bg=#2a2a2e,bold] Zellij "
                    mode_scroll        "#[fg=#767b82,bg=#2a2a2e,bold] {name} "
                    mode_enter_search  "#[fg=#767b82,bg=#2a2a2e,bold] {name} "
                    mode_search        "#[fg=#767b82,bg=#2a2a2e,bold] {name} "

                    tab_normal   " #[fg=#767b82,bg=#2a2a2e]{index}:{name}"
                    tab_active   " #[fg=#d99872,bg=#2a2a2e,bold]{index}:{name}"
                }
            }
        }
      }
    '';
  };
}
