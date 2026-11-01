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

## Nixpkgs sharing

`brew-nix` and `rose-pine-hyprcursor` follow the host `nixpkgs` input.
`nix/overlays/custom-packages.nix` evaluates their pinned upstream recipes with
the host package set: upstream brew-nix's overlay forwards `self.packages` and
does not rebase its build dependencies; the cursor input has no overlay.
Cask metadata, binary downloads, cursor sources, and upstream source pins are
unchanged. This shares the packaging toolchain, not the contents of vendor apps.

Do not make every input follow the host automatically. The host stays on its
existing 25.11 lineage; Neovim retains its own unstable/stable inputs, and pterm
retains its binary-cache-compatible pin. HyprPanel's old AGS package graph,
xremap's development inputs, and Zen's cache-backed package graph are not
rebased here. Existing substituters and trust settings are unchanged.

Fewer lock nodes are not a disk-space measurement. Reuse depends on actual
derivation paths and retained generations; this change does not delete store
paths, run garbage collection, or apply a system configuration.

A build-free regression check for source/version preservation and host-toolchain
reuse on Apple Silicon macOS and both Linux architectures is available with:

```sh
nix eval --impure --json --file tests/nixpkgs-sharing.nix
```
