{
  username,
  inputs,
  system,
  pkgs,
  config,
  lib,
  ...
}:
{
  home = lib.mkIf pkgs.stdenv.isDarwin {
    # https://texwiki.texjp.org/?Mac#defaultkeybinding-dict
    file."/Library/KeyBindings/DefaultKeyBinding.dict".text = ''
      {
        "¥" = ("insertText:", "\\");
        "~\\" = ("insertText:", "¥");
      }
    '';
    activation.aliasApplications =
      let
        hmApps = pkgs.buildEnv {
          name = "home-manager-applications";
          paths = config.home.packages;
          pathsToLink = "/Applications";
        };
        mkalias = inputs.mkAlias.outputs.apps.${system}.default.program;
      in
      lib.hm.dag.entryAfter [ "linkGeneration" ] ''
        applications="$HOME/Applications"
        if ! test -d "$applications"; then
        mkdir -p "$applications"
        chown ${username}: "$applications"
        chmod u+w "$applications"
        fi

        app_path="$HOME/Applications/HomeManagerApps"
        tmp_path="$(mktemp -dt "home-manager-applications.XXXX")" || exit 1

        find ${hmApps}/Applications -maxdepth 1 -type l 2>/dev/null | while IFS= read -r target_path
        do
          target_basename=$(basename $target_path)
          $DRY_RUN_CMD ${mkalias} -L "$target_path" "$tmp_path/$target_basename"
        done

        $DRY_RUN_CMD rm -rf "$app_path"
        $DRY_RUN_CMD mv "$tmp_path" "$app_path"
      '';
  };
}
