{ lib, config, customLib, ... }:
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
        type = with types; nullOr (listOf str);
        default = null;
        description = "Optional list of identities to add to keychain (ssh, gpg)";
      };
    };
  };


  ###### implementation
  config = mkIf cfg.enable {
    programs.zsh = {
      enable = true;

      initExtraFirst = strings.optionalString (customLib.nonEmpty cfg.keychainIdentities) ''
        zstyle :omz:plugins:keychain agents "gpg,ssh"
        zstyle :omz:plugins:keychain identities ${(builtins.concatStringsSep " " cfg.keychainIdentities)}
        zstyle :omz:plugins:keychain options --quiet

      '';

      initExtra = ''
        COMPLETION_WAITING_DOTS=true

        bindkey '^R' history-incremental-search-backward

        zstyle ':completion:*' menu yes select _complete _ignored _approximate _files

        setopt MENU_COMPLETE
        setopt HIST_IGNORE_ALL_DUPS
        setopt HIST_IGNORE_SPACE
        setopt HIST_REDUCE_BLANKS
        setopt APPEND_HISTORY
      '';
    };

    custom.programs.zsh-snap = {
      enable = true;
      sources = [
        {
          repo = "ohmyzsh/ohmyzsh";
          path = "lib/{git,functions,theme-and-appearance,history,key-bindings,completion,termsupport}";
        }
        {
          repo = "ohmyzsh/ohmyzsh";
          path = "plugins/{git,extract}";
        }
        (mkIf (customLib.nonEmpty cfg.keychainIdentities)
          {
            repo = "ohmyzsh/ohmyzsh";
            path = "plugins/{keychain,gpg-agent}";
          }
        )
      ];
    };

  };
}
