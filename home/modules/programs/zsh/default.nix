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

      envExtra = ''
        export VISUAL=vim
        export EDITOR="$VISUAL"
        export HOSTNAME=$(hostname)
      '';

      initExtraFirst = (builtins.readFile ./env_default.sh);

      initExtraBeforeCompInit = strings.optionalString (!customLib.isListNullOrEmpty cfg.keychainIdentities) ''
        zstyle :omz:plugins:keychain agents gpg,ssh
        zstyle :omz:plugins:keychain identities ${(builtins.concatStringsSep " " cfg.keychainIdentities)}
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

    custom.programs.zsh.snap = {
      enable = true;
      reposDir = "$HOME/.zsh-plugins";
      sources = [
        {
          repo = "ohmyzsh/ohmyzsh";
          subfolderPrefix = "lib";
          subfolders = [ "git" "theme-and-appearance" "history" "key-bindings" "misc" "completion" "directories" "termsupport" ];
        }
        {
          repo = "ohmyzsh/ohmyzsh";
          subfolderPrefix = "plugins";
          subfolders = [ "git" "command-not-found" "extract" ] ++
            lists.optionals (!customLib.isListNullOrEmpty cfg.keychainIdentities) [ "keychain" "gpg-agent" ];
        }
        {
          repo = "ptavares/zsh-direnv";
        }
        {
          repo = "ohmyzsh/ohmyzsh";
          subfolderPrefix = "themes";
          subfolders = [ "fletcherm.zsh-theme" ];
        }
      ];
    };

  };
}
