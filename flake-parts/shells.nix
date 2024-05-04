{ inputs, lib, ... }:
let
  flattenDerivationsToList = attrset:
    lib.concatLists (lib.mapAttrsToList
      (_: value:
        if lib.isDerivation value then flattenDerivationsToList value else [ value ]
      )
      attrset);

  mkShells = attrsets: lib.mergeAttrsList (flattenDerivationsToList attrsets);
in
{
  perSystem = { lib, pkgs, ... }: {
    devShells = mkShells (
      inputs.haumea.lib.load {
        src = ../shells;
        loader = inputs.haumea.lib.loaders.default;
        inputs = {
          inherit pkgs;
        };
      }
    );
  };
}
