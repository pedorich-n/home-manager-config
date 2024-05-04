{ haumea, lib }:
let
  # Given an attrset, takes all the values recursivelly and joins them into a single list
  foldAttrValuesToListRecursive = attrset:
    lib.concatLists (lib.mapAttrsToList
      (_: value:
        if builtins.isAttrs value then foldAttrValuesToListRecursive value else [ value ]
      )
      attrset);
in
{
  listNixFilesRecursive = path:
    foldAttrValuesToListRecursive (haumea.lib.load {
      src = path;
      loader = haumea.lib.loaders.path;
    });
}
