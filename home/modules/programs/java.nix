{ lib, config, pkgs, ... }:
with lib;
{
  config = mkMerge [
    { programs.java.package = mkDefault pkgs.jdk17; }
    (mkIf config.programs.java.enable {
      custom.runtimes.java = [ config.programs.java.package ];
    })
  ];
}
