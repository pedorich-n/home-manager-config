{
  description = "Multiple machines config managed by NIX Home-Manageger and Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    utils.url = "github:numtide/flake-utils";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zsh-snap = {
      url = "github:marlonrichert/zsh-snap";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, utils, home-manager, zsh-snap, ... }:
    let
      stateVersion = "22.11";

      pkgsFor = pkgs: system: import pkgs {
        inherit system;
        config.allowUnfree = true;
      };

    in
    with utils.lib; eachSystem [ system.x86_64-linux ]
      (system:
        let
          pkgs = pkgsFor nixpkgs system;
          pkgs-unstable = pkgsFor pkgs-unstable system;

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

