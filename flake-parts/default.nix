{ importApply, ... }@args:
let
  lib = args.inputs.nixpkgs.lib;
  updatedArgs = args // { inherit lib; };
in
[
  (importApply ./lib.nix updatedArgs)
  (importApply ./shells.nix updatedArgs)
]
