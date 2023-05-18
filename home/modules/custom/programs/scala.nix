{ pkgs, lib, config, ... }:
with lib;
let
  cfg = config.custom.programs.scala;
  cfgJdk = config.custom.programs.jdk;

in
{
  ###### interface
  options = {
    custom.programs.scala = {
      enable = mkEnableOption "Scala";

      version = mkOption {
        type = types.enum [ "2.10" "2.11" "2.12" "2.13" ];
        default = "2.13";
        description = "Major Scala 2.X version to install";
      };
    };
  };


  ###### implementation
  config =
    let
      scalaPkg =
        let
          scalaVersion = pkgs.scala.override { majorVersion = cfg.version; };
        in
        if cfgJdk.enable then scalaVersion.override { jre = cfgJdk.package; } else scalaVersion;


      additionalPkgs =
        let
          packages = with pkgs; [
            coursier
            bloop
            sbt
            ammonite
          ];
        in
        (if cfgJdk.enable then builtins.map (pkg: pkg.override { jre = cfgJdk.package; }) packages
        else packages) ++ [ scalaPkg ];
    in
    mkIf cfg.enable {
      home.packages = [ scalaPkg ] ++ additionalPkgs;

      custom.misc.sdkLinks.paths = {
        "scala-${cfg.version}" = scalaPkg;
      };
    };
}
