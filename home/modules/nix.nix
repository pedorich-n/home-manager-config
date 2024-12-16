{ nixpkgs, pkgs, lib, ... }:
let
  nixPkg = pkgs.nixVersions.nix_2_20;
  nixApps = with pkgs; [
    nil # NIX language server
    nixd # A better NIX language server
    nix-tree # Interative NIX depdencey graph
    nixPkg # NIX itself
    nixpkgs-fmt # NIX code formatter
  ];

  # Last time I had this enabled the download speeds were very slow. It was faster to download the sources and build locally :(
  # additionalCaches = {
  #   "http://nix-community.cachix.org" = "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=";
  # };
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
      # substituters = builtins.attrNames additionalCaches;
      # trusted-public-keys = builtins.attrValues additionalCaches;
    };
  };
}
