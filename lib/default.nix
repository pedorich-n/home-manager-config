{ haumea, lib }:
let
  # Given an attrset, takes all the values recursivelly and joins them into a single list
  foldAttrValuesToListRecursive = attrset:
    lib.foldl'
      (acc: value:
        if (lib.isPath value || lib.isString value || lib.isDerivation value) then
          acc ++ [ value ]
        else if (lib.isAttrs value) then
          acc ++ (foldAttrValuesToListRecursive value)
        else
          lib.trace value (abort "Unknown type of value!")
      )
      [ ]
      (builtins.attrValues attrset);
in
{
  listNixFilesRecursive = path:
    foldAttrValuesToListRecursive (haumea.lib.load {
      src = path;
      loader = haumea.lib.loaders.path;
    });
}
