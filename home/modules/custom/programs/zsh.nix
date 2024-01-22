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

      initExtraFirst = strings.optionalString (cfg.keychainIdentities != [ ]) ''
        zstyle :omz:plugins:keychain agents "gpg,ssh"
        zstyle :omz:plugins:keychain identities ${(builtins.concatStringsSep " " cfg.keychainIdentities)}
        zstyle :omz:plugins:keychain options --quiet

      '';

      initExtra = ''
        COMPLETION_WAITING_DOTS=true

        zstyle ':completion:*' menu yes select _complete _ignored _approximate _files

        setopt MENU_COMPLETE
        setopt HIST_IGNORE_ALL_DUPS
        setopt HIST_IGNORE_SPACE
        setopt HIST_REDUCE_BLANKS
        setopt APPEND_HISTORY

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
