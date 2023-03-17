{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.home;
  cfgCustom = config.custom.hm;

  home = "/home/${cfg.username}";

  nixPkg = pkgs.nix;
  commonApps = with pkgs; [
    bat
    curl
    delta
    gdu
    jq
    keychain
    nix-tree
    nixPkg
    nixpkgs-fmt
    nvd
    ripgrep
    rnix-lsp
    tmux
  ];

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

      packages = commonApps;

      shellAliases = lib.mkMerge [
        { hm = "home-manager"; }
        { hms = "home-manager switch --flake ${home}/.config.nix#${cfgCustom.name}"; }
        { hmd = ''home-manager generations | head -n 2 | tac | cut -d " " -f 7 | xargs nvd diff''; }
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
