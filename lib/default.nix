{ pkgs }:
with pkgs;
rec {
  # Works for strings, lists, attrsets
  isNullOrEmpty = elem:
    let
      type = builtins.typeOf elem;
    in
    if type == "null" then true
    else if (type == "string") then elem == ""
    else if (type == "list") then elem == [ ]
    else if (type == "set") then elem == { }
    else throw "Cannot check emptiness for type ${type}";

  nonEmpty = elem: !isNullOrEmpty elem;

  listNixFilesRecursive = path: builtins.filter (lib.hasSuffix ".nix") (lib.filesystem.listFilesRecursive path);

  flattenAttrsetsRecursive = list: builtins.foldl' lib.recursiveUpdate { } list;
}
