{
  inputs,
  flake,
  ...
}:
{
  imports = [
    inputs.home-manager.flakeModules.default
  ];

  flake.homeModules = {
    sharedModules = {
      imports = (flake.lib.loaders.listFilesRecursively { src = ../home/modules; }) ++ [
        inputs.plasma-manager.homeModules.plasma-manager
      ];
    };
  };
}
