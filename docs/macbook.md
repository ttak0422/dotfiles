# Standalone MacBook setup

Draft: Nix evaluation/build and macOS activation are not yet verified. Do not
activate this profile on a live account until those checks and the disposable-domain
preference-preservation test below have passed.

This Apple Silicon profile manages the user's shell, command-line tools,
Neovim v3, WezTerm configuration, key bindings and macOS user preferences.
Machine-level preferences stay in dotfiles; the development environment stays
in dotfiles-nvim. The existing `darwinConfigurations.darwin` remains unchanged.

## Install Nix once

The standard macOS Nix installation needs administrator access. It creates the
Nix store volume and a system daemon; Home Manager cannot remove that requirement.
Do not use a Linux `--no-daemon` recipe as a macOS workaround. If administrator
access is not acceptable even for initial installation, stop here.

Follow the [official macOS download instructions](https://nixos.org/download/).
Review the installer before executing it from your normal account:

```sh
curl --proto '=https' --tlsv1.2 -fL https://nixos.org/nix/install -o /tmp/nix-install
less /tmp/nix-install
sh /tmp/nix-install --daemon
```

The installer requests privileges itself. Reopen Terminal afterwards and check
`nix --version`. This repository does not execute the installer automatically.
See the [installation manual](https://nix.dev/manual/nix/stable/installation/installing-binary.html)
for the changes made by the installer and its platform requirements.

## Build and activate as your user

Clone the repository using Git (macOS may prompt to install Command Line Tools),
then run:

```sh
git clone https://github.com/ttak0422/dotfiles.git
cd dotfiles
make build-macbook
# Inspect the build and the preferences below before activating.
make apply-macbook
```

Neither command invokes sudo. The wrapper rejects root and non-Apple-Silicon
hosts. `USER` and `HOME` are read only at the flake's `homeConfigurations.macbook`
boundary, with `--impure`; no username is embedded in the tracked profile.
The wrapper supports the standard `/Users/<username>` home layout.
For an explicit account, reuse `nix/lib/macbook-home.nix` with literal arguments.

Nix may ask whether to trust the repository's configured binary caches. Review
that separately; the wrapper does not auto-accept it or modify daemon settings.
Home Manager stops on conflicting existing dotfiles instead of overwriting them.
Back up and move only the reported conflicts, then retry. Do not run the old
`apply-nix-darwin` targets on this new profile.

## Preferences and recovery

Finder, Dock and global user preferences reuse the existing dotfiles values.
Before the first import, activation saves the three domains to
`~/.local/state/dotfiles/defaults-before-home-manager`. The snapshot is retained
across later activations. It can contain personal preference data; keep it private.

The pinned Home Manager module uses `defaults import` per domain. Preservation
of undeclared keys has **not been verified on a Mac**. Before applying to an
existing account, test import and rollback against a disposable domain, including
an undeclared sentinel key. Do not let nix-darwin and standalone Home Manager own
the same preferences simultaneously. Some changes require logout/login.

Removing a declaration does not restore its old value. Switching Home Manager
generations restores declared values, not arbitrary previous macOS preferences.
To recover a domain, inspect its saved plist, then explicitly import that snapshot
with `/usr/bin/defaults import DOMAIN /path/to/DOMAIN.plist`. This can overwrite
changes made since the snapshot. If any domain cannot be exported, activation
stops before importing preferences (including when a domain does not yet exist).
Inspect the cause rather than bypassing the snapshot. Do not blindly delete a
whole live domain to undo an individual key.

## Deliberately not migrated

Login-window/security settings, system keyboard remapping, Nix daemon settings,
Homebrew installation, system LaunchDaemons and window-manager services are not
part of this user profile. Existing Macs are not automatically converted. GUI
applications, MacSKK and optional services can be added separately after checking
their installation/permission requirements. No developer runtimes are duplicated
from dotfiles-nvim.

The current repository lock is retained, including its older Nixpkgs/Home Manager
release. Updating those inputs is a separate compatibility check before using
this profile as a long-term new-machine baseline; `home.stateVersion` is not a
package release selector and should not be bumped just to update packages.

## Validation

```sh
python3 tests/macbook-wrapper.py
nix eval --impure --json --file tests/macbook-home.nix
make build-macbook
```

Evaluation does not activate preferences. A successful build alone does not prove
macOS activation, preference preservation or application behavior.
