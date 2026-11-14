# Next-generation workstation configuration

An independent nix-darwin + Home Manager configuration for a new Apple Silicon
Mac. It has its own flake and lock file and does not import legacy dotfiles
modules, shell scripts, Dhall files or assets. The repository's existing root
flake and hosts remain unchanged.

Draft: the full system build and macOS activation are not yet verified. Do not
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
worktree helpers, complete terminal keymaps/color scheme, optional GUI apps,
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

## Homebrew applications

Install [Homebrew](https://docs.brew.sh/Installation) as your normal account
before the first switch. nix-darwin manages its package list, not Homebrew itself:

```sh
curl --proto '=https' --tlsv1.2 -fL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh -o /tmp/homebrew-install
less /tmp/homebrew-install
/bin/bash /tmp/homebrew-install
/opt/homebrew/bin/brew --version
```

The initial installer may request administrator access. Use the Apple Silicon
prefix `/opt/homebrew`; do not run `brew` as root. A build does not require
Homebrew, but the switch wrapper checks that it exists before activating.

`modules/darwin/apps.nix` declares Chrome, OneDrive, ChatGPT, Slack,
Karabiner-Elements and macSKK. Activation installs missing casks without upgrading
existing ones, updating Homebrew metadata or removing unlisted packages. Casks are not
pinned by `flake.lock`; this configuration does not disable application self-updaters.
Install security updates promptly rather than waiting for a system switch.
Review Homebrew-managed updates explicitly, for example:

```sh
/opt/homebrew/bin/brew update
/opt/homebrew/bin/brew outdated --cask --greedy
/opt/homebrew/bin/brew upgrade --cask --greedy google-chrome onedrive chatgpt slack karabiner-elements macskk
```

Some casks use system package installers and can request administrator access.
Karabiner's required macOS permissions must be approved interactively. Existing
manually installed apps may conflict with cask installation; inspect conflicts
rather than forcing overwrite or removal. System generation rollback does not
roll back Homebrew application versions or their data. Input sources and IME
selection are not changed by this configuration.

After installing macSKK, follow its [installation guide](https://github.com/mtgto/macSKK/blob/main/docs/guide/install.md)
for dictionary setup and enabling its Hiragana and ABC modes. For macSKK-only
input sources, follow the [official FAQ](https://github.com/mtgto/macSKK/blob/main/docs/faq.md):
add both macSKK modes first, enable the English input mode of Apple's Japanese
source, then remove Apple's ABC and Japanese sources in System Settings.
Verify typing and mode switching before removing sources; keep a recovery input
source until that verification succeeds. macSKK checks for updates but does not
install them automatically; apply updates explicitly. No preference-file editing
or automatic removal of Apple input sources is performed here. This does not
guarantee the input method at login or FileVault unlock. Back up personal
dictionaries and retain a way to re-add Apple ABC before changing input sources.

## Build and apply

No `ghq` installation is needed. Use its conventional checkout location so the
repository is discoverable after the configuration installs `ghq`. Ensure Git
is available (`git --version`); on a fresh Mac, complete the Command Line Tools
installation if macOS prompts for it before continuing.

The following commands check out `main`.
The subshell stops if the destination already exists and never overwrites an
existing checkout:

```sh
(
  set -eu
  destination="$HOME/ghq/github.com/ttak0422/dotfiles"
  if [ -e "$destination" ] || [ -L "$destination" ]; then
    printf 'Checkout already exists; inspect it before continuing: %s\n' "$destination" >&2
    exit 1
  fi
  mkdir -p "$HOME/ghq/github.com/ttak0422"
  git clone --branch main \
    https://github.com/ttak0422/dotfiles.git "$destination"
  cd "$destination/next"
  ./scripts/macbook build
)
```

Only after the build succeeds, review
`$HOME/ghq/github.com/ttak0422/dotfiles/next/result/activate` and its generated
settings. Apply separately, from any current directory:

```sh
cd "$HOME/ghq/github.com/ttak0422/dotfiles/next" && ./scripts/macbook switch
```

If the checkout already exists, inspect its branch and local changes before
reusing it; do not delete, reset or replace it just to run these commands.

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

Nix evaluation and a build dry-run passed with the matching 26.05 inputs. The
full system build and macOS activation remain unverified. Review generated
activation scripts before applying; a successful build alone does not establish
correct activation.

The system inputs track the matching Nixpkgs, nix-darwin and Home Manager 26.05
release branches. Nixpkgs uses the macOS channel, `nixpkgs-26.05-darwin`.
Review macOS compatibility and update inputs
from this directory with
`nix --extra-experimental-features 'nix-command flakes' flake update` when ready. Updating `next/flake.lock`
does not update the legacy root lock. State-version values are compatibility
settings, not package release selectors. No existing Mac is automatically migrated.
