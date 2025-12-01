{
  description = "Multiple machines config managed by NIX Home-Manageger and Flake";

  inputs = {
    self.submodules = true;

    # Global / Meta
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # Version 12.1.0-unstable-2025-05-04
    nixpkgs-flameshot.url = "github:nixos/nixpkgs/640fe994e5d7815f1dccbc3f84316ff3b0cbd7a1";

    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default-linux";
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Packages / Overlays
    tomorrow-theme-source = {
      url = "github:chriskempson/tomorrow-theme";
      flake = false;
    };

    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
  };

  outputs =
    inputs@{ flake-parts, systems, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } (
      { lib, ... }:
      {
        debug = true; # Needed for nixd

        systems = import systems;

        imports = lib.filesystem.listFilesRecursive ./flake-parts;
      }
    );
}
