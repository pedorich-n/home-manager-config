{
  nixpkgs,
  pkgs,
  lib,
  ...
}:
let
  nixPkg = pkgs.nix;
  nixApps = with pkgs; [
    nixd # A better NIX language server
    nix-tree # Interative NIX depdencey graph
    nixPkg # NIX itself
    nixpkgs-fmt # NIX code formatter
    nixfmt # Official NIX code formatter
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

    settings = lib.mkDefault (
      lib.mkMerge [
        {
          experimental-features = [
            "nix-command"
            "flakes"
          ];
          log-lines = 50;
        }
        (lib.mkIf (lib.versionAtLeast nixPkg.version "2.26") {
          # See https://nix.dev/manual/nix/2.26/command-ref/conf-file.html#conf-allow-dirty-locks
          allow-dirty-locks = true;
        })
      ]
    );
  };
}
