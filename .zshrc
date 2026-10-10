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

autoload -U promptinit; promptinit
zstyle :prompt:error color '#F5C77E'
zstyle :prompt:success color '#87CEEB'
PURE_PROMPT_SYMBOL="❯❯❯"

# Show a short SHA for detached checkouts; keep Pure's actionformats unchanged.
zstyle -e ':vcs_info:git:*' formats '
  reply=("%b" "%R" "%a")
  command git symbolic-ref -q HEAD >/dev/null 2>&1 || reply[1]=$(command git rev-parse --short HEAD)
'

prompt pure

echo -ne '\e[6 q'
