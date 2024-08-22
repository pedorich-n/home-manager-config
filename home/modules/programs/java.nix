{ lib, config, pkgs, ... }:
{
  config = lib.mkMerge [
    { programs.java.package = lib.mkDefault pkgs.jdk17; }
    (lib.mkIf config.programs.java.enable {
      custom.runtimes.java = [ config.programs.java.package ];
    })
  ];
}
