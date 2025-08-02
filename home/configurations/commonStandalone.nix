# Module containing common settings for standalone HM installations.
{ config, lib, ... }:
let
  cfg = config.home;

  home = "/home/${cfg.username}";
  hmConfigLocation = "${cfg.homeDirectory}/home-manager-config";
in
{
  imports = [ ./common.nix ];

  home = {
    homeDirectory = lib.mkDefault home;
  };

  custom = {
    aliases = {
      enable = lib.mkDefault true;
      hm.enable = lib.mkDefault true;
      hms.enable = lib.mkDefault true;
    };

    programs = {
      # HomeManager Diff tool, built using NVM (Nix Version Diff)
      hmd = {
        enable = lib.mkDefault true;
        runOnSwitch = lib.mkDefault false;
      };
    };
  };

  programs = {
    nh = {
      enable = lib.mkDefault true;
      homeFlake = lib.mkDefault hmConfigLocation;
    };

    zsh = {
      dirHashes = {
        hmc = lib.mkDefault hmConfigLocation;
      };
    };
  };

  targets.genericLinux.enable = lib.mkDefault true;
}
