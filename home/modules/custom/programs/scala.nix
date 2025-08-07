{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.custom.programs.scala;
  cfgJava = config.programs.java;
in
{
  ###### interface
  options = with lib; {
    custom.programs.scala = {
      enable = mkEnableOption "Scala";

      version = mkOption {
        type = types.enum [
          "2.10"
          "2.11"
          "2.12"
          "2.13"
        ];
        default = "2.13";
        description = "Major Scala 2.X version to install";
      };
    };
  };

  ###### implementation
  config =
    let
      scalaPackage = pkgs.scala_2_13.override { majorVersion = cfg.version; };
      allPackages =
        let
          packages = with pkgs; [
            ammonite
            bloop
            coursier
            sbt
            scalaPackage
          ];
        in
        if cfgJava.enable then
          builtins.map (pkg: pkg.override { jre = cfgJava.package; }) packages
        else
          packages;
    in
    lib.mkIf cfg.enable {
      home.packages = allPackages;
      custom.runtimes.scala = [ scalaPackage ];
    };
}
