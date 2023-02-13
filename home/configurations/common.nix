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
    home = {
      inherit (cfg) username;
      homeDirectory = if (cfg.homeDirectory != null) then cfg.homeDirectory else "/home/${cfg.username}";

      packages = mkIf cfg.installCommonApps commonApps;
    };

    programs.home-manager.enable = true;
    targets.genericLinux.enable = cfg.genericLinux;

    nix = {
      package = pkgs.nix;

      settings = {
        experimental-features = [ "nix-command" "flakes" ];
        log-lines = 50;
      };
    };
  };
}
