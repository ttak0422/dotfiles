export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$PATH

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
