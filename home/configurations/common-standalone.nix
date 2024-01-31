# Module containing common settings for standalone HM installations.
{ config, lib, ... }:
with lib;
let
  cfg = config.home;

  home = "/home/${cfg.username}";
  hmConfigLocation = "${cfg.homeDirectory}/.config.nix";
in
{
  imports = [ ./common.nix ];

  home = {
    homeDirectory = mkDefault home;

    shellAliases = {
      # hms = ''home-manager switch --flake "${hmConfigLocation}#${cfgCustom.name}"'';
      # hmn = ''home-manager --flake "${hmConfigLocation}#${cfgCustom.name}" news'';
    };
  };

  custom.programs = {
    nh = {
      enable = true;
      flakeRef = mkDefault hmConfigLocation;
      aliases.homeManager = true;
    };
  };

  programs = {
    hmd.enable = false; # HomeManager Diff tool, built using NVM (Nix Version Diff)

    zsh = {
      dirHashes = {
        "hmc" = hmConfigLocation;
      };
    };
  };

  targets.genericLinux.enable = true;
}
