{ pkgs, lib, customLib, config, ... }:
with lib;
let
  cfg = config.custom.programs.git;
in
{
  ###### interface
  options = {
    custom.programs.git = {
      enable = mkEnableOption "git";

      userEmail = mkOption {
        type = types.str;
        description = "git.userEmail";
      };

      signingKey = mkOption {
        type = with types; nullOr str;
        default = null;
        description = "GPG key to use signing commits";
      };
    };
  };


  ###### implementation
  config = mkIf cfg.enable {
    programs.git = {
      enable = true;
      userName = "Nikita Pedorich";
      userEmail = cfg.userEmail;

      signing = {
        signByDefault = !customLib.isNullOrEmpty cfg.signingKey;
        key = cfg.signingKey;
      };

      extraConfig = {
        pull.rebase = true;
        push.default = "simple";
      };
    };
  };
}
