{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.home;
  cfgCustom = config.custom.hm;

  home = "/home/${cfg.username}";

  nixPkg = pkgs.nix;
  nixApps = with pkgs; [
    nix-tree
    nixPkg
    nixpkgs-fmt
    nvd
    rnix-lsp
  ];

  commonApps = with pkgs; [
    bat
    curl
    delta
    gdu
    jq
    keychain
    ripgrep
    tmux
  ];

  hmConfigLocation = "${home}/.config.nix";
in
{
  ###### interface
  options = {
    custom.hm = {
      name = mkOption {
        type = types.str;
        description = "Home-Manager Flake Configuration name; Used in alias for `home-manager switch #name`";
      };
    };
  };

  ###### implementation
  config = {
    home = {
      stateVersion = "22.11";

      homeDirectory = home;

      packages = nixApps ++ commonApps;

      shellAliases = lib.mkMerge [
        { hm = "home-manager"; }
        { hms = "home-manager switch --flake ${hmConfigLocation}#${cfgCustom.name}"; }
        { hmd = "python ${hmConfigLocation}/hmd.py"; }
      ];
    };

    programs = {
      home-manager.enable = true;
      less.enable = true;
    };
    targets.genericLinux.enable = true;

    nix = {
      package = nixPkg;

      settings = {
        experimental-features = [ "nix-command" "flakes" ];
        log-lines = 50;
      };
    };
  };
}
