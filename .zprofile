export PATH=$HOME/opt/bin:$PATH

export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$PATH

export PATH=$HOME/.cargo/bin:$PATH

export NODE_PATH=~/.npm-packages/lib/node_modules
export PATH=~/.npm-packages/bin:$PATH

export VOLTA_HOME=$HOME/.volta
export PATH=$VOLTA_HOME/bin:$PATH

if [[ -f /opt/homebrew/bin/brew ]]; then
  eval $(/opt/homebrew/bin/brew shellenv)
  export PATH=${PATH#/opt/homebrew/bin:}
  export PATH=${PATH#/opt/homebrew/sbin:}
  export PATH=$PATH:/opt/homebrew/bin:/opt/homebrew/sbin
fi

if [[ "$(uname)" == "Darwin" ]]; then
  # HACK: for neovim (see: https://github.com/yetone/avante.nvim/issues/315#issuecomment-2315957174)
  export XDG_RUNTIME_DIR="/tmp/"
fi
