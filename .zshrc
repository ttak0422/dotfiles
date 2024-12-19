HISTSIZE=100000
SAVEHIST=1000000

setopt no_beep
setopt nolistbeep

setopt hist_ignore_space
setopt hist_ignore_dups
setopt hist_ignore_all_dups
setopt hist_reduce_blanks
setopt hist_no_store
setopt extended_history
setopt inc_append_history
setopt share_history

setopt auto_pushd
setopt pushd_ignore_dups

setopt list_packed
setopt list_types

alias g='cd $(ghq root)/$(ghq list | fzf)';
alias gg="ghq get"
alias cat="bat"
alias ls="eza"
alias tree="eza -T"
alias "$"=""

fpath+=("$HOME/.zsh/plugins/pure/share/zsh/site-functions")
autoload -U promptinit; promptinit
zstyle :prompt:error color '#F5C77E'
zstyle :prompt:success color '#87CEEB'
PURE_PROMPT_SYMBOL="❯❯❯"
prompt pure
