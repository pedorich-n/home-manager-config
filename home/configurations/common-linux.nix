{ pkgs, pkgs-unstable, config, lib, customLib, ... }:
with lib;
let
  cfg = config.home;
  cfgCustom = config.custom.hm;

  homeDirectory = "/home/${cfg.username}";

  nixPkg = pkgs-unstable.nix;
  commonApps = with pkgs; [
    bat
    curl
    gdu
    jq
    keychain
    nixpkgs-fmt
    ripgrep
    rnix-lsp
    tmux
  ] ++ [ nixPkg ];

in
{
  ###### interface
  options = {
    custom.hm = {
      name = mkOption {
        type = with types; nullOr str;
        default = null;
        description = "Home-Manager Flake Configuration name; Used in alias for `home-manager switch #name`";
      };
    };
  };

  ###### implementation
  config = {
    home = {
      stateVersion = "22.11";

      inherit homeDirectory;

      packages = commonApps;

      shellAliases = lib.mkMerge [
        { hm = "home-manager"; }
        (mkIf (customLib.nonEmpty cfgCustom.name) { hms = "home-manager switch --flake ${homeDirectory}/.config.nix#${cfgCustom.name}"; })
      ];
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
  };
}
