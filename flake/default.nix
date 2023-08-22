{ inputs }:
let
  customLib = import ../lib { pkgs-lib = inputs.nixpkgs.lib; };

  pkgsFor = system: pkgs:
    import pkgs {
      inherit system;
      overlays = with inputs; [
        nix-vscode-extensions.overlays.default
        rust-overlay.overlays.default
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

  # Input: pkgs, attrs (schema: { <name> = <homeManagerConfigurationPath> })
  # Output: attrs (schema: { <name> = <homeManagerConfiguration> })
  homeManagerConfigurationsFor = pkgs: configurations:
    let
      sharedModules = customLib.listNixFilesRecursive ../home/modules;
      shellNamesModule = { config.custom.hm.shellNames = builtins.attrNames (shellsFor pkgs); };

      homeManagerConfigrationFor = configuration:
        inputs.home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = sharedModules ++ [ configuration shellNamesModule inputs.home-manager-diff.hmModule ];
          extraSpecialArgs = {
            inherit customLib;
            inherit (inputs) self nixpkgs;
          };
        };
    in
    builtins.mapAttrs (_: configuration: homeManagerConfigrationFor configuration) configurations;
in
{
  # Input attrs (schema: { system = { <name> = <homeManagerConfigurationPath> } })
  flakeFor = attrs:
    let
      # Input: withSystem, attrs (schema: { system = { <name> = <homeManagerConfigurationPath> } }
      #        withSystem :: String -> ({} -> {}), https://flake.parts/module-arguments.html#withsystem
      #        It brings everything defined in `perSystem` to the scope, so pkgs are with custom settings and overlays
      # Output: attrs (schema: { <name> = <homeManagerConfiguration>; })
      homeConfigurations = { withSystem }: inputs.nixpkgs.lib.attrsets.foldlAttrs
        (acc: system: configurationsPerSystem: acc // (withSystem system ({ pkgs, ... }: homeManagerConfigurationsFor pkgs configurationsPerSystem)))
        { }
        attrs;
    in
    inputs.flake-parts.lib.mkFlake { inherit inputs; } ({ withSystem, ... }: {
      systems = builtins.attrNames attrs;

      # all parameters: https://flake.parts/module-arguments.html#persystem-module-parameters
      perSystem = { pkgs, system, ... }: {
        # pkgs with overlays and custom settings, from: https://flake.parts/overlays.html#consuming-an-overlay
        _module.args.pkgs = pkgsFor system inputs.nixpkgs;

        devShells = shellsFor pkgs;
      };

      flake = {
        homeConfigurations = homeConfigurations { inherit withSystem; };
      };
    });
}
