export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$PATH

export NODE_PATH=~/.npm-packages/lib/node_modules
export PATH=~/.npm-packages/bin:$PATH

export VOLTA_HOME=$HOME/.volta
export PATH=$VOLTA_HOME/bin:$PATH

if [ "$(uname)" == 'Darwin' ]; then
  export PATH=$PATH:/opt/homebrew/bin
fi
