# dotfiles

## Platform support

macOS is supported on Apple Silicon (`aarch64-darwin`) only.
Intel macOS (`x86_64-darwin`) is no longer supported; the flake excludes it and no longer provides Intel Darwin package sets or extra-platform configuration.
The Linux host configuration targets `x86_64-linux`.

## Updating Homebrew on macOS

Homebrew and its taps are pinned by `nix-homebrew`; update the pins with
`make update-homebrew`, then run `make apply-nix-darwin` to build and activate them.
Updating `flake.lock` alone does not change the active Homebrew installation.

Activation upgrades the packages declared in `nix/modules/darwin/brew.nix`.
VS Code is included even though its cask supports automatic updates. Packages
outside that list are preserved (`cleanup = "none"`).

VS Code extensions are managed separately. Run `code --update-extensions` to
update installed extensions, then reload VS Code to use them.
