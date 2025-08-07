{ lib, config, ... }:
let
  cfg = config.custom.runtimes;

  getMajorVersion = pkg: lib.versions.major (lib.getVersion pkg);
  getMajorMinorVersion =
    pkg: lib.replaceStrings [ "." ] [ "_" ] (lib.versions.majorMinor (lib.getVersion pkg));
in
{
  ###### interface
  options = with lib; {
    custom.runtimes = {
      enable = mkEnableOption "Custom Runtimes";

      root = mkOption {
        type = types.str;
        default = ".runtimes";
        description = "The root directory for custom runtimes. Will be created under $HOME";
      };

      java = mkOption {
        type = with types; listOf package;
        default = [ ];
      };

      scala = mkOption {
        type = with types; listOf package;
        default = [ ];
      };
    };
  };

  ###### implementation
  config = lib.mkIf cfg.enable {
    # Inspired by https://github.com/gytis-ivaskevicius/nixfiles/blob/642487c1dd612a66ef5bc69c47e9fdf31cbfe3a6/modules/runtimes.nix
    home =
      let
        javaPkgs = lib.foldl' (acc: pkg: acc // { "${getMajorVersion pkg}" = pkg; }) { } (
          lib.unique cfg.java
        );
        javaEnvVariable = lib.mapAttrs' (
          version: pkg: lib.nameValuePair "JAVA_HOME_${version}" "${pkg.home}"
        ) javaPkgs;
        javaAliases = lib.mapAttrs' (
          version: pkg: lib.nameValuePair "java_${version}" "${lib.getExe pkg}"
        ) javaPkgs;
        javaRuntimeEntries = lib.mapAttrs' (
          version: pkg: lib.nameValuePair "${cfg.root}/java-${version}" { source = pkg.home; }
        ) javaPkgs;

        scalaPkgs = lib.foldl' (acc: pkg: acc // { "${getMajorMinorVersion pkg}" = pkg; }) { } (
          lib.unique cfg.scala
        );
        scalaAliases = lib.mapAttrs' (
          version: pkg: lib.nameValuePair "scala_${version}" ''${lib.getExe' pkg "scala"}''
        ) scalaPkgs;
        scalaRuntimeEntries = lib.mapAttrs' (
          version: pkg: lib.nameValuePair "${cfg.root}/scala-${version}" { source = pkg; }
        ) scalaPkgs;
      in
      {
        file = javaRuntimeEntries // scalaRuntimeEntries;
        shellAliases = javaAliases // scalaAliases;
        sessionVariables = javaEnvVariable;
      };
  };
}
