{
  inputs,
  flake,
  lib,
  ...
}:
{
  flake.overlays =
    let
      dir = ../overlays;
      overlayFiles = flake.lib.loaders.listFilesRecursively {
        src = dir;
      };

      getOverlayName = path: lib.removeSuffix ".nix" (baseNameOf path);
      overlayArgs = { inherit inputs; };
      overlays = lib.foldl' (acc: path: acc // { "${getOverlayName path}" = import path overlayArgs; }) { } overlayFiles;

      default = lib.composeManyExtensions (lib.attrValues overlays);
    in
    overlays // { inherit default; };
}
