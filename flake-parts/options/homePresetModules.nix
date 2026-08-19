{
  moduleLocation,
  flake-parts-lib,
  lib,
  ...
}:
{
  options = {
    flake = flake-parts-lib.mkSubmoduleOptions {
      homePresetModules = lib.mkOption {
        type = lib.types.lazyAttrsOf lib.types.deferredModule;
        default = { };
        apply = lib.mapAttrs (
          k: v: {
            _class = "homeManager";
            _file = "${toString moduleLocation}#homePresetModules.${k}"; # Helps with debugging
            imports = [ v ];
          }
        );
        description = ''
          Home Manager Preset Modules.

          Includes a collection of reusable modules that can be used as a base for home configurations.
        '';
      };
    };
  };
}
