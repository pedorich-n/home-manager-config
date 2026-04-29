{
  inputs,
  flake,
  ...
}:
{
  flake = {
    homeModules = {
      common = {
        imports = [ ../home/configurations/common.nix ];
      };
      sharedModules = {
        imports = (flake.lib.loaders.listFilesRecursively { src = ../home/modules; }) ++ [
          inputs.plasma-manager.homeModules.plasma-manager
        ];
      };
    };
  };
}
