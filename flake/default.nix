{ inputs }:
let
  flatMap = f: list: builtins.foldl' (acc: entry: acc // (f entry)) { } list;

  pkgsFor = system: pkgs:
    let
      customOverlays = import ../overlays inputs;
    in
    import pkgs {
      inherit system;
      overlays = [ inputs.nix-vscode-extensions.overlays.default customOverlays ];
      config.allowUnfree = true;
    };

  customLibFor = pkgs: import ../lib { inherit pkgs; };

  formatterFor = system:
    let
      pkgs = pkgsFor system inputs.nixpkgs;
    in
    pkgs.nixpkgs-fmt;

  checksFor = system:
    let
      pkgs = pkgsFor system inputs.nixpkgs;
    in
    {
      pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
        src = ../.;
        hooks = {
          # Nix
          deadnix.enable = true;
          nixpkgs-fmt.enable = true;
          statix.enable = true;

          # Python 
          black = {
            enable = true;
            entry = with pkgs; lib.mkForce "${lib.getExe black} --line-length=150";
          };
          isort.enable = true;

          # Shell
          shfmt.enable = true;
        };
      };
    };

  shellsFor = system:
    let
      pkgs = pkgsFor system inputs.nixpkgs;
      customLib = customLibFor pkgs;
      minimalMkShell = import ../lib/minimal-shell.nix { inherit pkgs; };

      preCommitShell = { "pre_commit" = minimalMkShell { inherit ((checksFor system).pre-commit-check) shellHook; }; };
      shells = builtins.map (path: import path { inherit pkgs minimalMkShell; }) (customLib.listNixFilesRecursive ../shells);

      allShells = [ preCommitShell ] ++ shells;
    in
    customLib.flattenAttrsetsRecursive allShells;

  homeManagerConfFor = system: configuration:
    let
      pkgs = pkgsFor system inputs.nixpkgs;
      customLib = customLibFor pkgs;

      sharedModules = customLib.listNixFilesRecursive ../home/modules;
      shellNamesModule = { config.custom.hm.shellNames = builtins.attrNames (shellsFor system); };
    in
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = sharedModules ++ [ configuration shellNamesModule ];
      extraSpecialArgs = {
        inherit customLib;
        inherit (inputs) self;
      };
    };
in
{
  # Input attrs (schema: { system = { name = nixPath } })
  flakeFor = attrs:
    let
      # Gets top-level names from attrs as a list
      supportedSystems = builtins.attrNames attrs;

      # eachSystem appends ${system} to the key of attrs, so
      # Output: attrs (schema: { checks.${system} = <checks>; devShells.${system} = <shells> })
      flakeOutputForSupportedSystems = inputs.flake-utils.lib.eachSystem supportedSystems (system: {
        # Schema: https://nixos.wiki/wiki/Flakes#Output_schema
        formatter = formatterFor system;
        checks = checksFor system;
        devShells = shellsFor system;
      });


      flakeOutputHomeConfigurations =
        let
          # Input: string, attrs (schema: { name = nixPath })
          # Output: attrs (schema: { name = homeManagerConfiguration })
          homeManagerConfigurationsFor = system: configurations: builtins.mapAttrs (_: configuration: homeManagerConfFor system configuration) configurations;

          # Flatmaps over all systems from attrs and builds home-manager configurations for these systems.
          # Ouputs: flat attrs (schema: { name = homeManagerConfiguration })
          allHomeConfigurations = flatMap (system: (homeManagerConfigurationsFor system (builtins.getAttr system attrs))) supportedSystems;
        in
        {
          # https://nix-community.github.io/home-manager/index.html#sec-flakes-standalone-stable
          homeConfigurations = allHomeConfigurations;
        };
    in
    flakeOutputForSupportedSystems // flakeOutputHomeConfigurations;
}
