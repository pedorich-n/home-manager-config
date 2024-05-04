{ importApply, ... }@args:
let
  lib = args.inputs.nixpkgs.lib;
  updatedArgs = args // { inherit lib; };
in
[
  #TODO - custom haumea loader using importApply
  (importApply ./lib.nix updatedArgs)
  (importApply ./pkgs.nix updatedArgs)
  (importApply ./home-configurations.nix updatedArgs)
  (importApply ./shells.nix updatedArgs)
]
