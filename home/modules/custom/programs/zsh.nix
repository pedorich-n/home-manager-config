{ lib, config, ... }:
with lib;
let
  cfg = config.custom.programs.zsh;
in
{
  ###### interface
  options = {
    custom.programs.zsh = {
      enable = mkEnableOption "zsh";

      keychainIdentities = mkOption {
        type = with types; listOf str;
        default = [ ];
        description = "Optional list of identities to add to keychain (ssh, gpg)";
      };
    };
  };


  ###### implementation
  config = mkIf cfg.enable {
    programs.zsh = {
      enable = true;

      history = {
        ignoreAllDups = true;
        ignoreDups = true;
        ignoreSpace = true;
        share = true;
      };

      initExtraFirst = strings.optionalString (cfg.keychainIdentities != [ ]) ''
        zstyle :omz:plugins:keychain agents "gpg,ssh"
        zstyle :omz:plugins:keychain identities ${(builtins.concatStringsSep " " cfg.keychainIdentities)}
        zstyle :omz:plugins:keychain options --quiet

      '';

      initExtra = ''
        set +o histexpand # Disable history expantion (annying exclamantion mark behaviour)

        zstyle ':completion:*' menu yes select _complete _ignored _approximate _files

        setopt MENU_COMPLETE # On ambiguous completion insert first match and show menu
        setopt HIST_REDUCE_BLANKS # Remove superfluous blanks from history
        setopt APPEND_HISTORY # Append history, rather than replace it. Multiple parallel zsh sessions will all write history to the histfile
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
        ] ++ (lists.optionals (cfg.keychainIdentities != [ ]) [
          "ohmyzsh/ohmyzsh path:plugins/keychain"
          "ohmyzsh/ohmyzsh path:plugins/gpg-agent"
        ]);
      };
    };
  };
}
