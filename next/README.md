# Next-generation workstation configuration

An independent nix-darwin + Home Manager configuration for a new Apple Silicon
Mac. It has its own flake and lock file and does not import legacy dotfiles
modules, shell scripts, Dhall files or assets. The repository's existing root
flake and hosts remain unchanged.

Draft: Nix evaluation/build and macOS activation are not yet verified. Do not
apply to a live account until the checks below and generated activation scripts
have been reviewed.

## Layout

```text
next/
  flake.nix, flake.lock      independent dependency boundary
  lib/mk-darwin.nix          explicit account-to-system constructor
  hosts/macbook.nix          machine composition and state versions
  profiles/home.nix          user feature selection
  modules/darwin/            system settings and macOS preferences
  modules/home/              shell, Git, tools, editor and terminal
  scripts/macbook            build/switch entry point
```

Hosts compose modules, profiles select user features, and modules own their
settings. Keep text configuration inline with its owning Nix module using
indented strings and language markers such as `# lua`; prefer typed Nix options
when available. External files are reserved for assets that are unsuitable for
inline text. The bootstrap script stays directly executable before Nix is ready.
Add future machines under `hosts/`; share only genuinely common
modules. Keep developer tools and Neovim configuration in dotfiles-nvim, consumed
by `modules/home/editor.nix`, rather than duplicating language runtimes here.

Existing behavior is a reference, not an implementation dependency. This baseline
retains selected Finder/Dock/keyboard preferences, Zsh completion and suggestions,
direnv, fzf, zoxide, Git conventions, terminal settings and Neovim v3. It does not
promise full legacy parity: custom shell functions/abbreviations, prompt theme,
worktree helpers, complete terminal keymaps/color scheme, Homebrew, GUI apps,
window-manager services and SKK daemons are deliberately not migrated.
Review those features individually rather than importing the old configuration.

## Privileges and initial installation

Initial Nix installation and system activation require administrator privileges.
Builds and everyday tool use do not. Integrated Home Manager is applied with the
system, so even user-only configuration changes use the system switch path.
There is no passwordless sudo setup or separate Home Manager activation.

Follow the [official macOS Nix instructions](https://nixos.org/download/).
Review the installer before running it as your normal account:

```sh
curl --proto '=https' --tlsv1.2 -fL https://nixos.org/nix/install -o /tmp/nix-install
less /tmp/nix-install
sh /tmp/nix-install --daemon
```

The installer requests privileges for the store and daemon. Reopen Terminal and
check `nix --version`. The scripts here never install Nix. This profile assumes
standard upstream Nix; independently managed Nix distributions need a separate
ownership review before nix-darwin manages their settings.

## Build and apply

```sh
git clone https://github.com/ttak0422/dotfiles.git
cd dotfiles/next
./scripts/macbook build
# Review result/activate and generated settings before proceeding.
./scripts/macbook switch
```

Run the wrapper without sudo. It rejects root, non-Apple-Silicon hosts and
nonstandard home paths. It derives the account from `id -un` and `/Users/<name>`,
then passes `DOTFILES_USERNAME` and `DOTFILES_HOME` explicitly into impure
resolution, including across sudo. It does not resolve the target from root's
USER/HOME. `lib/mk-darwin.nix` also accepts literal account arguments for
explicit host declarations.

Switch first builds as the user, then runs the built `darwin-rebuild switch`
with sudo. This records a system generation and activates it. Do not edit the
configuration between review and activation. Existing configuration-file
conflicts must be inspected and backed up, not force-overwritten. Do not apply
the legacy root flake to the new Mac.

Git identity is intentionally not taken from the legacy host file. Set it once
in the private, unmanaged file included by the Git module:

```sh
mkdir -p ~/.config/git
git config --file ~/.config/git/identity user.name 'YOUR NAME'
git config --file ~/.config/git/identity user.email 'YOUR EMAIL'
```

The terminal module supplies WezTerm configuration, not the application.
Install the application separately. nix-darwin manages its configured font
families through `modules/darwin/fonts.nix`: PlemolJP Console NF and JetBrains
Mono. System activation installs them under `/Library/Fonts/Nix Fonts`; fonts
outside that managed directory are left alone. Restart WezTerm after activation
if its font list has not refreshed.

## Preferences and recovery

nix-darwin owns `system.defaults` and writes declared keys individually as the
primary user. Home Manager does not import preference domains. Before the first
switch, keep a private backup of each affected domain:

```sh
backup=$(mktemp -d "$HOME/dotfiles-preferences.XXXXXX")
for domain in NSGlobalDomain com.apple.finder com.apple.dock; do
  /usr/bin/defaults export "$domain" "$backup/$domain.plist" || exit 1
done
printf 'Keep these snapshots private: %s\n' "$backup"
```

Investigate export failures before applying. Review generated defaults commands;
undeclared-key preservation and application behavior still need macOS validation.
Some preferences need logout/login or an application restart.

`sudo darwin-rebuild --list-generations` lists system generations;
`sudo darwin-rebuild --rollback` selects the previous one if it exists. There is
no previous generation on first installation. This does not fully undo preference
writes, installer changes or user data. Removing a declaration does not restore
its previous value. Restore individual keys deliberately using the snapshot;
whole-domain imports can overwrite subsequent changes. Never blindly delete a
live preference domain.

## Validation and updates

```sh
./scripts/macbook build
```

Nix evaluation, build and macOS activation remain unverified. Review generated
activation scripts before applying; a successful build alone does not establish
correct activation.

The independent lock starts with the repository's current pinned versions, not
an implicit dependency upgrade. Review macOS compatibility and update inputs
from this directory with
`nix --extra-experimental-features 'nix-command flakes' flake update` when ready. Updating `next/flake.lock`
does not update the legacy root lock. State-version values are compatibility
settings, not package release selectors. No existing Mac is automatically migrated.
