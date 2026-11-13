{ lib, ... }:
let
  finder = (import ../../darwin/prelude/finder.nix).system.defaults.finder;
  dock = (import ../../darwin/prelude/dock.nix).system.defaults.dock;
  global = (import ../../darwin/prelude/ng-global.nix { user = "unused"; }).system.defaults.NSGlobalDomain;
in
{
  targets.darwin.defaults = {
    "com.apple.finder" = finder;
    "com.apple.dock" = dock;
    NSGlobalDomain = global;
  };

  # Preserve a first-use snapshot before Home Manager imports whole domains.
  # Removing an option or switching generations does not undo defaults writes.
  home.activation.backupMacbookDefaults = lib.hm.dag.entryBetween [ "setDarwinDefaults" ] [ "writeBoundary" ] ''
    backup="$HOME/.local/state/dotfiles/defaults-before-home-manager"
    if [ ! -d "$backup" ]; then
      if [ -n "''${DRY_RUN_CMD:-}" ]; then
        echo "Would back up macOS defaults to $backup"
      else
        temporary=$(/usr/bin/mktemp -d "$HOME/.dotfiles-defaults.XXXXXX")
        for domain in NSGlobalDomain com.apple.finder com.apple.dock; do
          if ! /usr/bin/defaults export "$domain" "$temporary/$domain.plist"; then
            echo "Cannot back up $domain; refusing to import preferences." >&2
            echo "Inspect the domain and temporary snapshot at $temporary before retrying." >&2
            exit 1
          fi
        done
        mkdir -p "$(dirname "$backup")"
        mv "$temporary" "$backup"
      fi
    fi
  '';
}
