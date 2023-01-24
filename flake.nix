{
  description = "Multiple machines config managed by NIX Home-Manageger and Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-utils.url = "github:numtide/flake-utils";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zsh-snap = {
      url = "github:marlonrichert/zsh-snap";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, flake-utils, home-manager, zsh-snap, ... }:
    with flake-utils.lib; eachSystem [ system.x86_64-linux ]
      (system:
        let
          stateVersion = "22.11";

          pkgsFor = pkgs: import pkgs {
            inherit system;
            config.allowUnfree = true;
          };

          pkgs = pkgsFor nixpkgs;
          pkgs-unstable = pkgsFor nixpkgs-unstable;

          homeManagerConfFor = path: home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            modules = [ path ];
            extraSpecialArgs = { inherit pkgs-unstable zsh-snap stateVersion; };
          };
        in
        {
          packages.homeConfigurations = {
            wslPersonal = homeManagerConfFor ./home/configurations/wsl-personal.nix;
            linuxWork = homeManagerConfFor ./home/configurations/linux-work.nix;
          };
        });
}

