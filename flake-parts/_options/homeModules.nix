# Based on https://github.com/hercules-ci/flake-parts/blob/567b938d64d4b4112ee253b9274472dc3a346eb6/modules/nixosModules.nix 
# And https://github.com/hercules-ci/flake-parts/pull/213/files#diff-623d4066c90d27ca3056381f452c4b61738b39592b5a6edfbde44e84dc886a6d
{ lib, flake-parts-lib, ... }: {
  options = {
    flake = flake-parts-lib.mkSubmoduleOptions {
      homeModules = lib.mkOption {
        type = with lib.types; lazyAttrsOf deferredModule;
        default = { };
      };
    };
  };
}
