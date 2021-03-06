{ config, pkgs, lib, ... }:

let
  sources = import ./../../../nix/sources.nix;
  shared = import ./shared.nix {
    pkgs = pkgs;
    shell-type = "fish";
  };
in {
  home.packages = with pkgs; [ starship ];
  programs.fish = {
    enable = true;
    functions = {
      # https://github.com/oh-my-fish/plugin-peco/blob/master/functions/peco_select_history.fish
      peco_select_history = ''
        if test (count $argv) = 0
         set peco_flags --layout=bottom-up
        else
         set peco_flags --layout=bottom-up --query "$argv"
        end

        history|peco $peco_flags|read foo

        if [ $foo ]
          commandline $foo
        else
          commandline ""
        end
      '';
      fish_user_key_bindings = "bind \\cr peco_select_history";
    };
    plugins = [{
      name = "fish-kubectl-completions";
      src = sources.fish-kubectl-completions;
    }];
    shellAbbrs = shared.abbrevs.static;
    shellAliases = shared.shellAliases;
    promptInit = ''
      # starship
      starship init fish | source
    '';
  };
}
