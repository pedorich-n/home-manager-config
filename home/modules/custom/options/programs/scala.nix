{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.custom.programs.scala;
  cfgJava = config.programs.java;

  allPackages =
    let
      rawPackages = [ cfg.package ] ++ cfg.extraPackages;
    in
    if cfgJava.enable then
      map (pkg: pkg.override { jre = cfgJava.package; }) rawPackages
    else
      rawPackages;
in
{
  options = with lib; {
    custom.programs.scala = {
      enable = mkEnableOption "Scala";

      package = mkPackageOption pkgs "scala_2_13" { };

      extraPackages = mkOption {
        type = types.listOf types.package;
        default = [];
        example = lib.literalExpression ''
          [
            pkgs.ammonite
          ]
        '';
        description = ''
          Extra Scala packages to install

          ::: {.note}
          If `custom.programs.java.enable` is set, these packages will be installed with the specified Java runtime.
          :::
        '';
      };

      sbtOptions = mkOption {
        type = types.lines;
        default = [ ];
        example = [
          "-J-Xmx8G"
          "--client"
        ];
        description = ''
          SBT launcher options to write to the `$XDG_CONFIG_HOME/sbt/sbtopts` file.

          ::: {.note}
          Pass JVM options with the `-J` prefix.
          :::
        '';
      };
    };
  };

  config =
    let
    in
    lib.mkIf cfg.enable {
      home.packages = allPackages;

      xdg.configFile."sbt/sbtopts" = lib.mkIf (cfg.sbtOptions != [ ]) {
        text = cfg.sbtOptions;
      };
      custom.runtimes.scala = [ cfg.package ];
    };
}
