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

    shellAliases = {
      # hms = ''home-manager switch --flake "${hmConfigLocation}#${cfgCustom.name}"'';
      # hmn = ''home-manager --flake "${hmConfigLocation}#${cfgCustom.name}" news'';
    };
  };

  custom.programs = {
    nh = {
      enable = lib.mkDefault true;
      flakeRef = lib.mkDefault hmConfigLocation;
      aliases.homeManager = lib.mkDefault true;
    };
  };

  programs = {
    # HomeManager Diff tool, built using NVM (Nix Version Diff)
    hmd = {
      enable = lib.mkDefault true;
      runOnSwitch = lib.mkDefault false;
    };


    zsh = {
      dirHashes = {
        "hmc" = hmConfigLocation;
      };
    };
  };

  targets.genericLinux.enable = lib.mkDefault true;
}
