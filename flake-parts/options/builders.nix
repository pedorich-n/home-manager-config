{
  flake,
  inputs,
  withSystem,
  flake-parts-lib,
  lib,
  ...
}:
let
  availablePresets = lib.attrNames flake.homePresetModules;

  mkPresetModules = presets: lib.map (preset: flake.homePresetModules.${preset}) presets;

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
          ++ [
            {
              custom.configName = lib.mkDefault name;
            }
          ]
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
