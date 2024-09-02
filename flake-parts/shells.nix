{ inputs, ... }:
{
  perSystem = { lib, pkgs, ... }:
    let
      # Flattens an attrset of arbitrary depth, where the values are either derivations or attrsets into a flat attrset of derivations.
      flattenDerivations = derivations: lib.foldl'
        (acc: attrset:
          if lib.isDerivation attrset.value then
            acc // { ${attrset.name} = attrset.value; }
          else if lib.isAttrs attrset.value then
            acc // (flattenDerivations attrset.value)
          else
            lib.trace attrset (abort "Unknown type in attrset")
        )
        { }
        (lib.attrsToList derivations);
    in
    {
      devShells = flattenDerivations (
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
