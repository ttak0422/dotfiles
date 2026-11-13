# MacBook setup

Draft: Nix evaluation/build and macOS activation are not yet verified. Do not
activate on a live account until the checks below pass and the generated
activation scripts have been reviewed.

## Ownership and privileges

The Apple Silicon `darwinConfigurations.macbook` profile uses nix-darwin for
system configuration, Nix settings, shell integration and macOS preferences.
Home Manager is integrated into that system for user shell configuration, tools,
WezTerm and key bindings. The development environment remains in dotfiles-nvim
(`v3/default`). Existing Darwin and Linux hosts are unchanged.

- Initial Nix installation needs administrator access for the store and daemon.
- Evaluation and builds run as the normal user, without sudo.
- Applying the nix-darwin system requires sudo each time, including Home Manager
  changes applied through this integrated configuration.
- Normal use of installed tools and Neovim does not require sudo.

This is not a sudo-free system-management profile. Do not run a separate Home
Manager switch against the same files or preferences.

## Install Nix once

Follow the [official macOS instructions](https://nixos.org/download/).
Review the installer before executing it from your normal account:

```sh
curl --proto '=https' --tlsv1.2 -fL https://nixos.org/nix/install -o /tmp/nix-install
less /tmp/nix-install
sh /tmp/nix-install --daemon
```

The installer requests privileges. Reopen Terminal and check `nix --version`.
This repository does not execute the installer. See the
[installation manual](https://nix.dev/manual/nix/stable/installation/installing-binary.html).
The profile assumes standard upstream Nix managed by nix-darwin; an independently
managed Nix distribution needs a separate ownership review before activation.

## Build, review, apply

```sh
git clone https://github.com/ttak0422/dotfiles.git
cd dotfiles
make build-macbook
# Review result-macbook/activate and the generated configuration first.
make apply-macbook
```

Both targets must be invoked as the normal user. The wrapper rejects root,
non-Apple-Silicon hosts and nonstandard home paths. It derives the target from
`id -un` and `/Users/<username>`, then passes `DOTFILES_USERNAME` and
`DOTFILES_HOME` explicitly to impure evaluation, including across sudo. It never
uses root's USER/HOME as the target. For explicit account construction, reuse
`nix/lib/macbook-system.nix` with literal arguments.

The apply target first builds without privileges, then invokes that build's
`darwin-rebuild switch` with sudo. This records a system generation and activates
it. No passwordless sudo rule is installed. The rebuild may evaluate the same
locked configuration again; do not edit it between review and activation.
Configured binary-cache trust is not automatically accepted.

Preferences are owned solely by nix-darwin's `system.defaults`. The pinned
implementation writes declared keys individually as `system.primaryUser`.
Home Manager does not import preference domains.

## Preferences and recovery

Finder, Dock and global preferences reuse existing dotfiles values. Before the
first activation, export private snapshots as the normal user:

```sh
backup=$(mktemp -d "$HOME/dotfiles-preferences.XXXXXX")
for domain in NSGlobalDomain com.apple.finder com.apple.dock; do
  /usr/bin/defaults export "$domain" "$backup/$domain.plist" || exit 1
done
printf 'Keep these snapshots private: %s\n' "$backup"
```

A failed export needs investigation before applying. The snapshots may contain
personal information. No existing domains were changed during development.
Review the generated defaults commands before activation: preservation of
undeclared preferences and actual macOS behavior still need live validation.
Some changes require logout/login or application restart.

Use `sudo darwin-rebuild --list-generations` to inspect system generations and
`sudo darwin-rebuild --rollback` to activate the previous one when it exists.
There is no previous nix-darwin generation on first installation. Generation
rollback is not a complete rollback of macOS preference writes, user data, or
installer changes. Removing a preference declaration does not restore its old
value. Restore individual keys deliberately from the snapshot; importing a whole
snapshot can overwrite later changes. Do not blindly delete a live domain.

Home Manager and nix-darwin may stop on existing configuration-file conflicts.
Inspect and back up only the reported files instead of force-overwriting them.
Do not apply the old `darwin` host configuration to the new MacBook.

## Scope and validation

This baseline intentionally does not copy existing host-specific window-manager
services, Homebrew, system keyboard remapping, login-window settings or SKK
daemons. These can be added as explicit nix-darwin modules after installation
and permission requirements are reviewed. No automatic Rosetta installation is
performed. Developer runtimes remain in dotfiles-nvim.

The current lock is retained. Verify compatibility with the new Mac's macOS
version before adopting it long-term; dependency upgrades are separate from
`system.stateVersion` and `home.stateVersion` compatibility settings.

```sh
python3 tests/macbook-wrapper.py
nix eval --impure --json --file tests/macbook-system.nix
make build-macbook
```

The wrapper test uses mocks and never calls real sudo or activates a system.
Nix evaluation/build and a real macOS activation remain pending. Review the
nix-darwin defaults output and integrated Home Manager activation before any
live test; a successful build alone does not prove correct activation.
