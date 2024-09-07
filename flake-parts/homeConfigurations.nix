{ flake, lib, ... }:
{
  flake.homeConfigurations = lib.mkMerge [
    (flake.lib.builders.mkHomeConfiguration {
      system = "x86_64-linux";
      name = "wslPersonal";
    })
    (flake.lib.builders.mkHomeConfiguration {
      system = "x86_64-linux";
      name = "linuxWork";
    })
  ];
}
