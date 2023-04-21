{ pkgs, lib, customLib, config, ... }:
with lib;
let
  cfg = config.custom.development.environments;
  javaCfg = config.custom.programs.jdk;

  scalaSubmodule = types.submodule {
    options = {
      enable = mkEnableOption "Scala";
      version = mkOption {
        type = types.enum [ "2.10" "2.11" "2.12" "2.13" ];
        default = "2.13";
        description = "Major Scala 2.X version to install";
      };
    };
  };

  aliasesSubmodule = types.submodule {
    options = {
      root = mkOption {
        type = types.str;
        default = ".sdks";
        description = "Root folder for aliases (under $HOME)";
      };

      additionalPackages = mkOption {
        type = with types; attrsOf path;
        default = { };
        description = "Arbitrary aliases";
      };
    };
  };

  buildAliasAttrFor = path: source: (lib.attrsets.nameValuePair "${cfg.aliases.root}/${path}" { inherit source; });
  buildAliasForCfg = name: path: source: lib.attrsets.optionalAttrs cfg.${name}.enable (buildAliasAttrFor path source);
  buildAliasesForPackages = lib.attrsets.mapAttrsToList buildAliasAttrFor;

in
{
  ###### interface
  options = {
    custom.development.environments = {
      enable = mkEnableOption "Development Environments";

      scala = mkOption {
        type = scalaSubmodule;
        default = { };
      };

      aliases = mkOption {
        type = aliasesSubmodule;
        default = { };
      };
    };
  };


  ###### implementation
  config =
    let
      scalaEnabled = cfg.scala.enable;
      enabled = cfg.enable || scalaEnabled;

      jdkAlias = lib.attrsets.optionalAttrs javaCfg.enable (buildAliasAttrFor "java-17" javaCfg.package);

      scala =
        let
          scalaVersion = pkgs.scala.override { majorVersion = cfg.scala.version; };
        in
        if javaCfg.enable then scalaVersion.override { jre = javaCfg.package; } else scalaVersion;


      scalaPkgs =
        let
          scalaPkgsVanilla = with pkgs; [
            coursier
            bloop
            sbt
            ammonite
          ];
        in
        (if javaCfg.enable then builtins.map (pkg: pkg.override { jre = javaCfg.package; }) scalaPkgsVanilla
        else scalaPkgsVanilla) ++ [ scala ];

      scalaAlias = buildAliasForCfg "scala" "scala-${cfg.scala.version}" scala;

      allAliases = [ jdkAlias scalaAlias ] ++ (buildAliasesForPackages cfg.aliases.additionalPackages);
    in
    mkIf enabled {
      programs.vscode.userSettings = {
        "metals.javaHome" = "${config.home.homeDirectory}/${jdkAlias.name}";
      };

      home = {
        packages = scalaPkgs;

        file = with builtins; listToAttrs (filter customLib.nonEmpty allAliases);
      };
    };
}
