{
  inputs,
  flake,
  lib,
  ...
}:
{
  imports = [
    inputs.home-manager.flakeModules.default
  ];

  flake.homePresetModules =
    let
      presetsRoot = "${flake}/home/presets";
      availablePresets = lib.attrNames (lib.filterAttrs (_: type: type == "directory") (builtins.readDir presetsRoot));
      mkPresetModule = preset: {
        ${preset} = {
          _class = "homeManager";
          _file = "${presetsRoot}/${preset}"; # Helps with debugging
          imports = flake.lib.loaders.listFilesRecursively { src = "${presetsRoot}/${preset}"; };
        };
      };
    in
    lib.foldl' (acc: preset: acc // (mkPresetModule preset)) { } availablePresets;

}
