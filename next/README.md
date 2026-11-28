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
Line Tools installation if macOS prompts for it.

Set your Git identity in the private file included by this configuration:

```sh
mkdir -p "$HOME/.config/git"
git config --file "$HOME/.config/git/identity" user.name 'YOUR NAME'
git config --file "$HOME/.config/git/identity" user.email 'YOUR EMAIL'
```

Both `macbook build` and `macbook switch` check this file before starting a
Nix build. From the repository root you can also run `make preflight-next`.

Then clone and build:

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

Open Ghostty after applying the configuration; its settings and fonts are included.
Complete application sign-ins and macOS permission prompts as needed.

### Neru keyboard navigation

After applying, quit Homerow if it is still running so it does not claim the
same shortcut; apps already installed through Homebrew are left in place. If
Homerow relaunches on login, turn off its login item. Run
`neru doctor` and review the macOS permissions it reports for Neru. Use
Command+Shift+Space for Hints. This configuration does not switch input sources.

### macSKK and the local dictionary server

Home Manager starts [azoo-key-skkserv](https://github.com/gitusp/azoo-key-skkserv)
on `127.0.0.1:1178` at login. The pinned Apple Silicon CLI bundles the Zenzai
model, and conversion happens locally. On the first build Nix downloads the
upstream CLI archive (about 335 MB). Home Manager manages one SKK job,
`org.nix-community.home.skk-server`, for either backend.

After applying `next`, open macSKK's input menu → Settings → Dictionary.
Enable **SKKServ**, open its **i** details, and configure:

- Address: **127.0.0.1**
- TCP port: **1178**
- Heading/request encoding: **EUC-JP** (fixed on older macSKK versions)
- Response encoding: **UTF-8**

Run **Connection Test** and save the settings. See the
[official dictionary settings](https://github.com/mtgto/macSKK/blob/main/docs/config/dictionary.md).
macSKK can use only one SKK server at a time. To keep the familiar
`SKK-JISYO.L` candidates, add it as a macSKK file dictionary alongside Azoo.
Keep your existing learned dictionary. If you're comparing candidates, you can
temporarily turn off saving SKKServ conversion history to the user dictionary.

To roll back, set `dotfiles.skk.useYaskkserv2 = true;` in the user's Home
Manager configuration and apply `next` again. This restores the local
`SKK-JISYO.L` server with Google lookup disabled. The address, port and
encodings stay the same, so there is no macSKK change on rollback.

If another process already listens at `127.0.0.1:1178`, the new job logs a
conflict (search for `dotfiles-skk` in Console) without stopping that process.
Stop the conflicting listener yourself; launchd will retry. You can inspect
the job with `launchctl print "gui/$(id -u)/org.nix-community.home.skk-server"`.

Follow the [installation guide](https://github.com/mtgto/macSKK/blob/main/docs/guide/install.md)
to enable macSKK's Hiragana and ABC modes. To use macSKK
as the only input source, follow the [official FAQ](https://github.com/mtgto/macSKK/blob/main/docs/faq.md).
Verify typing and mode switching before removing Apple's input sources. These
input-source changes are manual, not part of `switch`.
