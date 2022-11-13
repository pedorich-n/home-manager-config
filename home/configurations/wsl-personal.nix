{ config, pkgs, pkgs-unstable, ... }:
let
  username = "pedorich_n";
  is-wsl = "" != builtins.getEnv "WSL_DISTRO_NAME";
in
{
  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "22.05";

  programs.home-manager.enable = true;

  imports = [
    ../modules/programs/zsh
    ../modules/programs/git.nix
    ../modules/packages/common.nix
  ];

  programs = {
    git = {
      userEmail = "pedorich.n@gmail.com";
      signing = {
        key = "ADC7FB37D4DF4CE2";
        signByDefault = false;
      };
    };
  };
}
