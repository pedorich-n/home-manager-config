{ flake, ... }: {
  imports = [
    ./_options/homeModules.nix
  ];

  flake = {
    homeModules = {
      common = { imports = [ ../home/configurations/common.nix ]; };
      sharedModules = { imports = flake.lib.loaders.listNixFiles ../home/modules; };
    };
  };
}
