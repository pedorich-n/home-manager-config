{
  description = "A very basic flake";

  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-22.05";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zsh-snap = {
      url = "github:marlonrichert/zsh-snap";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, zsh-snap }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      homeConfigurations = {
        wslPersonal = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./home/configurations/wsl-personal.nix ];
          extraSpecialArgs = {
            inherit pkgs-unstable;
            inherit zsh-snap;
            username = "pedorich_n";
            stateVersion = "22.05";
          };
        };
      };
    };
}

