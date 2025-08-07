# Based on https://github.com/hercules-ci/flake-parts/blob/567b938d64d4b4112ee253b9274472dc3a346eb6/modules/nixosConfigurations.nix
{ lib, flake-parts-lib, ... }:
{
  options = {
    flake = flake-parts-lib.mkSubmoduleOptions {
      homeConfigurations = lib.mkOption {
        type = with lib.types; lazyAttrsOf raw;
        default = { };
      };
    };
  };
}
