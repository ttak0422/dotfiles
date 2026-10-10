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

# Configure vcs_info before Pure starts its async worker.
# Show a short commit SHA instead of a tag or branch-relative name when detached.
function +vi-detached-head-sha() {
  if ! command git symbolic-ref -q HEAD >/dev/null 2>&1; then
    local sha
    sha=$(command git rev-parse --short HEAD 2>/dev/null) || return 0
    hook_com[branch]=$sha
  fi
  return 0
}
zstyle ':vcs_info:git+post-backend:*' hooks detached-head-sha

prompt pure

echo -ne '\e[6 q'
