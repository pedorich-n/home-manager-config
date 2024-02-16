{ inputs }:
let
  customLib = import ../lib { pkgs-lib = inputs.nixpkgs.lib; };

  pkgsForBare = system: pkgs: import pkgs {
    inherit system;
  };

  pkgsFor = system: pkgs:
    import pkgs {
      inherit system;
      overlays = with inputs; [
        nix-vscode-extensions.overlays.default
        rust-overlay.overlays.default
        nixgl.overlays.default
        (import ../overlays inputs)
      ];
      config = {
        allowUnfree = true;
        allowInsecurePredicate = pkg: (builtins.match "openssl-1\.1\.1.*" pkg.pname) != [ ];
      };
    };

  shellsFor = pkgs:
    let
      minimalMkShell = import ../lib/minimal-shell.nix { inherit pkgs; };

      shells = builtins.map (path: import path { inherit pkgs minimalMkShell; }) (customLib.listNixFilesRecursive ../shells);
    in
    customLib.flattenAttrsetsRecursive shells;

  # Input: { pkgs, attrs (schema: { <name> = <homeManagerConfigurationPath> }), extraArgs }
  # Output: list of attrs (schema: { name = <name>; value = <homeManagerConfiguration> })
  homeManagerConfigurationsFor = { pkgs, configurations, extraArgs ? { } }:
    let
      sharedModules = customLib.listNixFilesRecursive ../home/modules;
      nixGLWrap = pkgs.callPackage ../lib/nixgl-wrap.nix { };

      homeManagerConfigrationFor = configuration:
        inputs.home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = sharedModules ++ [
            configuration
            inputs.home-manager-diff.hmModules.default
          ];
          extraSpecialArgs = {
            inherit customLib;
            inherit nixGLWrap;
            inherit (inputs) self nixpkgs;
          } // extraArgs;
        };
    in
    pkgs.lib.mapAttrsToList (name: configuration: { inherit name; value = homeManagerConfigrationFor configuration; }) configurations;
in
{
  # Input attrs (schema: { system = { <name> = <homeManagerConfigurationPath> } })
  flakeFor = attrs:
    let
      systems = builtins.attrNames attrs;

      # Input: withSystem :: String -> ({} -> {}), https://flake.parts/module-arguments.html#withsystem
      #        It brings everything defined in `perSystem` to the scope, e.g. `pkgs`, `system`, `lib`, etc.
      # Output: attrs (schema: { <name> = <homeManagerConfiguration>; })
      homeConfigurations = withSystem:
        let
          # Output: list of attrs (schema: { name = <name>; value = <homeManagerConfiguration> })
          mkForSystem = system: withSystem system ({ pkgs, pkgs-gnome-extensions, ... }:
            homeManagerConfigurationsFor { inherit pkgs; configurations = attrs.${system}; extraArgs = { inherit pkgs-gnome-extensions; }; }
          );
        in
        builtins.listToAttrs (builtins.concatMap mkForSystem systems);
    in
    inputs.flake-parts.lib.mkFlake { inherit inputs; } ({ withSystem, ... }: {
      inherit systems;

      # all parameters: https://flake.parts/module-arguments.html#persystem-module-parameters
      perSystem = { pkgs, system, ... }: {
        _module.args = {
          # pkgs with overlays and custom settings, from: https://flake.parts/overlays.html#consuming-an-overlay
          pkgs = pkgsFor system inputs.nixpkgs;
          pkgs-gnome-extensions = pkgsForBare system inputs.nixpkgs-gnome-extensions;
        };

        devShells = shellsFor pkgs;
      };

      flake = {
        homeConfigurations = homeConfigurations withSystem;

        homeModules = {
          common = import ../home/configurations/common.nix;
        };
      };
    });
}
