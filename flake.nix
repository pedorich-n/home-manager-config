{
  description = "Multiple machines config managed by NIX Home-Manageger and Flake";

  inputs = {
    # Global / Meta
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    # nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.05";

    flake-utils.url = "github:numtide/flake-utils"; # Only here to have single entry in the flake.lock

    flake-parts.url = "github:hercules-ci/flake-parts";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
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

    home-manager-diff = {
      url = "github:pedorich-n/home-manager-diff";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
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
