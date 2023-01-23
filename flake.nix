{
  description = "Multiple machines config managed by NIX Home-Manageger and Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";
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
      stateVersion = "22.11";
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

            custom-params.git = {
              email = "pedorich.n@gmail.com";
              signing_key = "ADC7FB37D4DF4CE2";
            };
            username = "pedorich_n";
            stateVersion = stateVersion;
          };
        };

        linuxWork = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./home/configurations/linux-work.nix ];
          extraSpecialArgs = {
            inherit pkgs-unstable;
            inherit zsh-snap;

            custom-params.git = {
              email = "pedorich.n@gmail.com";
              signing_key = "900C2FE784D62F8C";
            };
            username = "mykytapedorich";
            stateVersion = stateVersion;
          };
        };
      };
    };
}

