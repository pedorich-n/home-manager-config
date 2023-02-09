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

    nix-formatter-pack = {
      url = "github:Gerschtli/nix-formatter-pack";
    };

    zsh-snap = {
      url = "github:marlonrichert/zsh-snap";
      flake = false;
    };

    pyenv-flake = {
      url = "github:pyenv/pyenv";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, flake-utils, home-manager, nix-formatter-pack, zsh-snap, pyenv-flake, ... }:
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

          formatterPackArgs = {
            inherit system pkgs;
            checkFiles = [ self ];
            config = {
              tools = {
                deadnix.enable = false;
                nixpkgs-fmt.enable = true;
                statix.enable = true;
              };
            };
          };

          customLib = import ./lib { };

          homeManagerConfFor = module: home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            modules = [
              { home.stateVersion = stateVersion; }
              module
            ];
            extraSpecialArgs = { inherit pkgs-unstable zsh-snap pyenv-flake customLib; };
          };
        in
        {
          # Schema: https://nixos.wiki/wiki/Flakes#Output_schema

          checks.nix-formatter-pack-check = nix-formatter-pack.lib.mkCheck formatterPackArgs;
          formatter = nix-formatter-pack.lib.mkFormatter formatterPackArgs;

          #devShells = builtins.mapAttrs (name: path: import path { inherit pkgs; }) shells;

          homeConfigurations = {
            wslPersonal = homeManagerConfFor ./home/configurations/wsl-personal.nix;
            linuxWork = homeManagerConfFor ./home/configurations/linux-work.nix;
          };
        });
}

