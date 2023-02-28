{ pkgs, pkgs-unstable, config, ... }:
let
  cfg = config.home;

  nixPkg = pkgs-unstable.nix;
  commonApps = with pkgs; [
    keychain
    curl
    bat
    ripgrep
    jq
    tmux
    fira-code
    nixPkg
  ];

in
{
  home = {
    stateVersion = "22.11";

    homeDirectory = "/home/${cfg.username}";

    packages = commonApps;

    shellAliases = { global-nix = "/nix/var/nix/profiles/default/bin/nix"; };
  };

  programs.home-manager.enable = true;
  targets.genericLinux.enable = true;

  nix = {
    package = nixPkg;

    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      log-lines = 50;
    };
  };
}
