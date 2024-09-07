{ flake, ... }: {
  flake = {
    homeModules = {
      common = { imports = [ ../home/configurations/common.nix ]; };
      sharedModules = { imports = flake.lib.loaders.listNixFiles { src = ../home/modules; }; };
    };
  };
}
