{
  description = "Multiple machines config managed by NIX Home-Manageger and Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-22.11";

    flake-utils.url = "github:numtide/flake-utils";

    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        nixpkgs-stable.follows = "nixpkgs-stable";
        flake-compat.follows = "flake-compat";
        flake-utils.follows = "flake-utils";
      };
    };

    zsh-snap-source = {
      url = "github:marlonrichert/zsh-snap";
      flake = false;
    };

    tomorrow-theme-source = {
      url = "github:chriskempson/tomorrow-theme";
      flake = false;
    };

    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "flake-compat";
        flake-utils.follows = "flake-utils";
      };
    };

    rtx-flake = {
      url = "github:jdxcode/rtx";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
  };

  outputs = { flake-utils, ... } @ inputs:
    with flake-utils.lib; let
      flakeLib = import ./flake { inherit inputs; };

      checks = eachDefaultSystem (system: {
        checks.pre-commit-check = flakeLib.checksFor system;
      });

      shells = eachDefaultSystem (system: {
        devShells = flakeLib.shellsFor system;
      });
    in
    {
      # Schema: https://nixos.wiki/wiki/Flakes#Output_schema
      homeConfigurations = with flake-utils.lib.system; with flakeLib; {
        wslPersonal = homeManagerConfFor x86_64-linux ./home/configurations/wsl-personal.nix;
        linuxWork = homeManagerConfFor x86_64-linux ./home/configurations/linux-work.nix;
      };
    } // checks // shells;
}
