{ pkgs, lib, customLib, config, ... }:
with lib;
let
  cfg = config.custom.home;

  commonApps = with pkgs; [
    keychain
    curl
    bat
    ripgrep
    jq
    tmux
    fira-code
  ];

  commonAppsStr = with builtins; concatStringsSep ", " (map (pkg: pkg.pname or pkg.name) commonApps);
in
{
  ###### interface
  options = {
    custom.home = {
      username = mkOption {
        type = types.str;
        description = "Username";
      };

      homeDirectory = mkOption {
        type = with types; nullOr path;
        default = null;
        defaultText = "/home/$username";
        description = "Home directory path";
      };

      genericLinux = mkOption {
        type = types.bool;
        description = "Sets targets.genericLinux.enable";
      };

      installCommonApps = mkOption {
        type = types.bool;
        description = "If true installs these packages: ${commonAppsStr}";
      };
    };
  };


  ###### implementation
  config = {
    home.username = cfg.username;
    home.homeDirectory = if (cfg.homeDirectory != null) then cfg.homeDirectory else "/home/${cfg.username}";

    home.packages = mkIf cfg.installCommonApps commonApps;

    programs.home-manager.enable = true;
    targets.genericLinux.enable = cfg.genericLinux;
  };
}
