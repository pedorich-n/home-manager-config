COMPLETION_WAITING_DOTS=true

bindkey '^R' history-incremental-search-backward

zstyle ':completion:*' menu yes select _complete _ignored _approximate _files

setopt MENU_COMPLETE
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt APPEND_HISTORY