{
  flake,
  inputs,
  withSystem,
  flake-parts-lib,
  lib,
  ...
}:
let
  presetsRoot = "${flake}/home/presets";
  availablePresets = lib.attrNames (lib.filterAttrs (_: type: type == "directory") (builtins.readDir presetsRoot));

  mkPresetModules =
    presets:
    let
      mkPresetModule = preset: {
        _file = "${./builders.nix}#hmPresetModules.${lib.escapeNixIdentifier preset}"; # Helps with debugging
        imports = flake.lib.loaders.listFilesRecursively { src = "${presetsRoot}/${preset}"; };
      };
    in
    lib.map mkPresetModule presets;

  loadConfig = name: flake.lib.loaders.listFilesRecursively { src = "${flake}/home/configurations/${name}"; };

  mkHomeConfig =
    name: cfg:
    withSystem cfg.system (
      { pkgs, ... }:
      inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules =
          lib.optional cfg.withSharedModules flake.homeModules.sharedModules
          ++ (mkPresetModules cfg.presets)
          ++ cfg.extraModules
          ++ (loadConfig name);
        extraSpecialArgs = {
          inherit flake inputs;
        };
      }
    );
in
{
  imports = [
    inputs.home-manager.flakeModules.default
  ];

  options.flake = flake-parts-lib.mkSubmoduleOptions {
    builders = {
      homeConfigurations = lib.mkOption {
        type = lib.types.attrsOf (
          lib.types.submodule {
            options = {
              system = lib.mkOption {
                type = lib.types.enum (import inputs.systems);
                description = "The system type for the home configuration";
              };

              withSharedModules = lib.mkOption {
                type = lib.types.bool;
                description = "Whether to include the common shared modules";
                default = true;
              };

              presets = lib.mkOption {
                type = lib.types.listOf (lib.types.enum availablePresets);
                description = "Presets to include";
                default = [ ];
              };

              extraModules = lib.mkOption {
                type = lib.types.listOf lib.types.deferredModule;
                description = "Additional modules to include";
                default = [ ];
              };
            };
          }
        );
        default = { };
      };
    };
  };

  config.flake = {
    homeConfigurations = lib.mapAttrs mkHomeConfig flake.builders.homeConfigurations;
  };
}
