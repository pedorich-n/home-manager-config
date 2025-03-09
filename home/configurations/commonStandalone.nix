# Module containing common settings for standalone HM installations.
{ config, lib, ... }:
let
  cfg = config.home;

  home = "/home/${cfg.username}";
  hmConfigLocation = "${cfg.homeDirectory}/.config.nix";
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
  };

  programs = {
    # HomeManager Diff tool, built using NVM (Nix Version Diff)
    hmd = {
      enable = lib.mkDefault true;
      runOnSwitch = lib.mkDefault false;
    };

    nh = {
      enable = lib.mkDefault true;
      flake = hmConfigLocation;
    };

    zsh = {
      dirHashes = {
        "hmc" = hmConfigLocation;
      };
    };
  };

  targets.genericLinux.enable = lib.mkDefault true;
}
