# MacBook setup

Set up a new Apple Silicon Mac with nix-darwin and Home Manager.
Run these commands as your normal macOS account, not from a root shell.
Installation and system activation will request administrator access.

## 1. Install Nix and Homebrew

Use the command from the [official Nix macOS instructions](https://nixos.org/download/):

```sh
curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install | sh
```

Then use the [official Homebrew installer](https://brew.sh/):

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Complete each installer's prompts and printed next steps, then reopen Terminal.

## 2. Clone and build

Git is required, but `ghq` is not. Run `git --version` and finish the Command
Line Tools installation if macOS prompts for it, then run:

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

This checks out `main` without replacing an existing directory. The script uses
the current account and expects its home at `/Users/<username>`.

## 3. Apply

After the build succeeds, review the configuration and
`$HOME/ghq/github.com/ttak0422/dotfiles/next/result/activate`, then apply:

```sh
cd "$HOME/ghq/github.com/ttak0422/dotfiles/next" && ./scripts/macbook switch
```

Run the wrapper without `sudo`; it requests privileges when needed. Use the
`next` configuration, not the repository's legacy root flake. If existing files
or applications conflict, inspect them rather than forcing an overwrite.
The full system build and activation on a fresh Mac have not yet been verified.

## 4. Finish setup

Set your Git identity in the private file included by this configuration:

```sh
mkdir -p "$HOME/.config/git"
git config --file "$HOME/.config/git/identity" user.name 'YOUR NAME'
git config --file "$HOME/.config/git/identity" user.email 'YOUR EMAIL'
```

Install [WezTerm](https://wezterm.org/installation.html) separately; its settings
and fonts are supplied by this configuration. Complete application sign-ins and
macOS permission prompts as needed.

For macSKK, follow the [installation guide](https://github.com/mtgto/macSKK/blob/main/docs/guide/install.md)
to configure dictionaries and enable its Hiragana and ABC modes. To use macSKK
as the only input source, follow the [official FAQ](https://github.com/mtgto/macSKK/blob/main/docs/faq.md).
Verify typing and mode switching before removing Apple's input sources. These
input-source changes are manual, not part of `switch`.
