{ nixpkgs, pkgs, pkgs-nix, lib, ... }:
let
  nixPkg = pkgs-nix.nixVersions.nix_2_20;
  nixApps = with pkgs; [
    nil # NIX language server
    pkgs-nix.nixd # A better NIX language server
    nix-tree # Interative NIX depdencey graph
    nixPkg # NIX itself
    nixpkgs-fmt # NIX code formatter
  ];
in
{
  home = {
    packages = nixApps;
  };

  nix = {
    package = lib.mkDefault nixPkg;

    registry = lib.mkDefault { nixpkgs.flake = nixpkgs; };

    nixPath = lib.mkDefault [
      "nixpkgs=${pkgs.path}"
    ];

    settings = lib.mkDefault {
      experimental-features = [ "nix-command" "flakes" ];
      log-lines = 50;
    };
  };
}
