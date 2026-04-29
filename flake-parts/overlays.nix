{
  inputs,
  flake,
  lib,
  ...
}:
{
  flake.overlays =
    let
      overlayFiles = flake.lib.loaders.listFilesRecursively {
        src = ../overlays;
      };

      getOverlayName = path: lib.removeSuffix ".nix" (baseNameOf path);
      overlayArgs = { inherit inputs; };
      overlays = lib.foldl' (acc: path: acc // { "${getOverlayName path}" = import path overlayArgs; }) { } overlayFiles;

      default = lib.composeManyExtensions (lib.attrValues overlays);
    in
    overlays // { inherit default; };
}
