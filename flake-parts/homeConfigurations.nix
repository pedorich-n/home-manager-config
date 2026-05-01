{
  inputs,
  flake,
  lib,
  ...
}:
{
  imports = [
    inputs.home-manager.flakeModules.default
  ];

  flake.homeConfigurations = lib.mkMerge [
    (flake.lib.builders.mkHomeConfiguration {
      system = "x86_64-linux";
      name = "wslPersonal";
    })
    (flake.lib.builders.mkHomeConfiguration {
      system = "x86_64-linux";
      name = "linuxWork";
    })
    (flake.lib.builders.mkHomeConfiguration {
      system = "x86_64-linux";
      name = "desktopPersonal";
    })
  ];
}
