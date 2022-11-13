COMPLETION_WAITING_DOTS=true

bindkey '^R' history-incremental-search-backward

zstyle ':completion:*' menu yes select _complete _ignored _approximate _files

setopt AUTO_MENU

setopt HIST_REDUCE_BLANKS
setopt APPEND_HISTORY
