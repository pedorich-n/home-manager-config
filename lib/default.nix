{ pkgs-lib }:
with pkgs-lib;
rec {
  listFilesWithExtension = ext: path: builtins.filter (hasSuffix ext) (filesystem.listFilesRecursive path);

  listNixFilesRecursive = path: listFilesWithExtension ".nix" path;

  flattenAttrsetsRecursive = list: builtins.foldl' recursiveUpdate { } list;

  mapListToAttrs = with builtins; func: list: listToAttrs (map func list);
}
