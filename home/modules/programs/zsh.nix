{ config, ... }:
{
  programs.zsh = {

    history = {
      append = true; # Append history, rather than replace it. Multiple parallel zsh sessions will all write history to the histfile
      ignoreAllDups = true; # Delete old recorded entry if new entry is a duplicate.
      ignoreDups = true; # Don't record an entry that was just recorded again.
      ignoreSpace = true; # Don't record an entry starting with a space.
      share = true; # Share history between all sessions.
    };

    initExtra = ''
      set +o histexpand # Disable history expantion (annying exclamantion mark behaviour)

      zstyle ':completion:*' menu yes select _complete _ignored _approximate _files

      setopt MENU_COMPLETE # On ambiguous completion insert first match and show menu
      setopt HIST_REDUCE_BLANKS # Remove superfluous blanks from history
      unsetopt EXTENDED_GLOB # Don't treat the '#', '~' and '^' characters as part of patterns for filename generation, etc.

      include () {
          [[ -f "$1" ]] && source "$1"
      }

      include "${config.home.homeDirectory}/.zshrc_extra";
    '';

    antidote = {
      enable = true;
      plugins = [
        "ohmyzsh/ohmyzsh path:lib/completion.zsh"
        "ohmyzsh/ohmyzsh path:lib/functions.zsh"
        "ohmyzsh/ohmyzsh path:lib/git.zsh"
        "ohmyzsh/ohmyzsh path:lib/key-bindings.zsh"
        "ohmyzsh/ohmyzsh path:lib/termsupport.zsh"
        "ohmyzsh/ohmyzsh path:plugins/extract"
        "ohmyzsh/ohmyzsh path:plugins/fzf"
        "ohmyzsh/ohmyzsh path:plugins/git kind:defer"
      ];
    };
  };
}
