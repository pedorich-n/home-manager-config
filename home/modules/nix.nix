{ pkgs, nixpkgs, ... }:
let
  nixPkg = pkgs.nix;
  nixApps = with pkgs; [
    nil # NIX language server
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
    sessionVariables.NIX_PATH = "nixpkgs=${nixpkgs}";
  };

  nix = {
    package = nixPkg;

    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      log-lines = 50;
      # substituters = builtins.attrNames additionalCaches;
      # trusted-public-keys = builtins.attrValues additionalCaches;
    };
  };
}
