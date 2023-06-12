{ pkgs }:
with pkgs;
rec {
  listFilesWithExtension = ext: path: builtins.filter (lib.hasSuffix ext) (lib.filesystem.listFilesRecursive path);

  listNixFilesRecursive = path: listFilesWithExtension ".nix" path;

  flattenAttrsetsRecursive = list: builtins.foldl' lib.recursiveUpdate { } list;

  mapListToAttrs = with builtins; func: list: listToAttrs (map func list);
}
