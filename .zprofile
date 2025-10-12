export PATH=$HOME/opt/bin:$PATH

export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$PATH

export PATH=$HOME/.cargo/bin:$PATH

export NODE_PATH=~/.npm-packages/lib/node_modules
export PATH=~/.npm-packages/bin:$PATH

export VOLTA_HOME=$HOME/.volta
export PATH=$VOLTA_HOME/bin:$PATH

export BAT_THEME="ansi"

if [[ -f /opt/homebrew/bin/brew ]]; then
  export HOMEBREW_PREFIX="/opt/homebrew";
  export HOMEBREW_CELLAR="/opt/homebrew/Cellar";
  export HOMEBREW_REPOSITORY="/opt/homebrew/Library/.homebrew-is-managed-by-nix";
  fpath[1,0]="/opt/homebrew/share/zsh/site-functions";
  export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}";
  export PATH=$PATH:/opt/homebrew/bin:/opt/homebrew/sbin
fi

if [ -f "$HOME/.profile" ]; then
  source "$HOME/.profile"
fi

if [[ "$(uname)" == "Darwin" ]]; then
  # HACK: for neovim (see: https://github.com/yetone/avante.nvim/issues/315#issuecomment-2315957174)
  export XDG_RUNTIME_DIR="/tmp/"
fi
