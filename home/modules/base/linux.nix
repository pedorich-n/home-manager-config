{ pkgs, pkgs-unstable, lib, customLib, config, ... }:
with lib;
let
  cfg = config.custom.base.linux;

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
    custom.base.linux = {
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

      installNix = {
        enable = mkEnableOption "install Nix";
        package = mkOption {
          type = types.package;
          default = pkgs.nixVersions.nix_2_12;
          description = "Nix package to install and use";
        };
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

      packages = with pkgs.lib.lists;
        (optionals (cfg.installCommonApps) commonApps) ++
        (optional (cfg.installNix.enable) cfg.installNix.package);

      shellAliases = mkIf (cfg.installNix.enable) { global-nix = "/nix/var/nix/profiles/default/bin/nix"; };
    };

    programs.home-manager.enable = true;
    targets.genericLinux.enable = cfg.genericLinux;

    nix = {
      package = if (cfg.installNix.enable) then cfg.installNix.package else pkgs.nix;

      settings = {
        experimental-features = [ "nix-command" "flakes" ];
        log-lines = 50;
      };
    };
  };
}
