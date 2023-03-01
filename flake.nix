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
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zsh-snap-flake = {
      url = "github:marlonrichert/zsh-snap";
      flake = false;
    };

    pyenv-flake = {
      url = "github:pyenv/pyenv";
      flake = false;
    };

    tomorrow-night-flake = {
      url = "github:chriskempson/tomorrow-theme";
      flake = false;
    };

    nix-vscode-extensions ={
      url = "github:nix-community/nix-vscode-extensions";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, flake-utils, home-manager, nix-formatter-pack, zsh-snap-flake, pyenv-flake, tomorrow-night-flake, ... }:
    let
      pkgsFor = system: pkgs: import pkgs {
        inherit system;
        config.allowUnfree = true;
      };

      formatterPackArgsFor = system:
        let
          pkgs = pkgsFor system nixpkgs;
        in
        {
          inherit system pkgs;
          checkFiles = [ self ];
          config = {
            tools = {
              deadnix.enable = true;
              nixpkgs-fmt.enable = true;
              statix.enable = true;
            };
          };
        };

      homeManagerConfFor = system: module:
        let
          pkgs = pkgsFor system nixpkgs;
          pkgs-unstable = pkgsFor system nixpkgs-unstable;

          customLib = import ./lib { inherit pkgs; };

          sharedModules = customLib.listNixFilesRecursive "${self}/home/modules/";
        in
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ module ] ++ sharedModules;
          extraSpecialArgs = { inherit self pkgs-unstable customLib zsh-snap-flake pyenv-flake tomorrow-night-flake; };
        };

      formatters = with flake-utils.lib; eachDefaultSystem (system: {
        formatter = nix-formatter-pack.lib.mkFormatter (formatterPackArgsFor system);
      });

      checks = with flake-utils.lib; eachDefaultSystem (system: {
        checks.nix-formatter-pack-check = nix-formatter-pack.lib.mkCheck (formatterPackArgsFor system);
      });
    in
    {
      # Schema: https://nixos.wiki/wiki/Flakes#Output_schema

      #devShells = builtins.mapAttrs (name: path: import path { inherit pkgs; }) shells;

      homeConfigurations = with flake-utils.lib.system; {
        wslPersonal = homeManagerConfFor x86_64-linux ./home/configurations/wsl-personal.nix;
        linuxWork = homeManagerConfFor x86_64-linux ./home/configurations/linux-work.nix;
      };
    } // formatters // checks;
}

