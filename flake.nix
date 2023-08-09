{
  description = "Multiple machines config managed by NIX Home-Manageger and Flake";

  inputs = {
    # Global / Meta
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.05";

    flake-utils.url = "github:numtide/flake-utils"; # Only here to have single entry in the flake.lock

    flake-parts.url = "github:hercules-ci/flake-parts";

    flake-compat = {
      url = "github:edolstra/flake-compat"; # Only here to have single entry in the flake.lock
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

    # Packages / Overlays
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

    cqlsh-source = {
      url = "github:jeffwidman/cqlsh";
      flake = false;
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
  };

  outputs = { flake-utils, ... } @ inputs:
    let
      flakeLib = import ./flake { inherit inputs; };
    in
    with flake-utils.lib.system; flakeLib.flakeFor {
      ${x86_64-linux} = {
        wslPersonal = ./home/configurations/wsl-personal.nix;
        linuxMinimal = ./home/configurations/linux-minimal.nix;
        linuxWork = ./home/configurations/linux-work.nix;
      };
    };
}
