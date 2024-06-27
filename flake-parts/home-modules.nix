{ flake, ... }: {
  flake = {
    homeModules = {
      common = import ../home/configurations/common.nix;
      sharedModules = flake.lib.listNixFilesRecursive ../home/modules;
    };
  };
}
