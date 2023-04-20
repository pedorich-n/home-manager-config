{ pkgs, lib, customLib, config, ... }:
with lib;
let
  cfg = config.custom.development.environments;

  # java-17-default = pkgs.temurin-bin-17; # TODO: try this out
  java-17-default = pkgs.jdk17;

  jdkSubmodule = types.submodule {
    options = {
      enable = mkEnableOption "JDK";
      package = mkOption {
        type = types.package;
        default = java-17-default;
        description = "JDK to use";
      };
    };
  };

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

      jdk = mkOption {
        type = jdkSubmodule;
        default = { };
      };

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
      jdkEnabled = cfg.jdk.enable;
      scalaEnabled = cfg.scala.enable;
      enabled = cfg.enable || jdkEnabled || scalaEnabled;

      jdkPkgs = lists.optional jdkEnabled cfg.jdk.package;
      jdkAlias = buildAliasForCfg "jdk" "java-17" cfg.jdk.package;

      scala = pkgs.scala.override { majorVersion = cfg.scala.version; jre = cfg.jdk.package; };

      scalaPkgs = lists.optionals scalaEnabled
        (with pkgs; [
          scala
          (coursier.override { jre = cfg.jdk.package; })
          (bloop.override { jre = cfg.jdk.package; })
          (sbt.override { jre = cfg.jdk.package; })
          (ammonite.override { jre = cfg.jdk.package; })
        ]);

      scalaAlias = buildAliasForCfg "scala" "scala-${cfg.scala.version}" scala;

      allAliases = [ jdkAlias scalaAlias ] ++ (buildAliasesForPackages cfg.aliases.additionalPackages);
    in
    mkIf enabled {
      programs.vscode.userSettings = {
        "metals.javaHome" = "${config.home.homeDirectory}/${jdkAlias.name}";
      };

      home = {
        packages = jdkPkgs ++ scalaPkgs;

        file = with builtins; listToAttrs (filter customLib.nonEmpty allAliases);
      };
    };
}
