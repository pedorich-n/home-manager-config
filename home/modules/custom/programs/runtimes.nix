{ lib, config, ... }:
with lib;
let
  cfg = config.custom.runtimes;

  getMajorVersion = pkg: versions.major (getVersion pkg);
  getMajorMinorVersion = pkg: replaceStrings [ "." ] [ "_" ] (versions.majorMinor (getVersion pkg));
in
{
  ###### interface
  options = {
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
  config = mkIf cfg.enable {
    # Inspired by https://github.com/gytis-ivaskevicius/nixfiles/blob/642487c1dd612a66ef5bc69c47e9fdf31cbfe3a6/modules/runtimes.nix
    home =
      let
        javaPkgs = foldl' (acc: pkg: acc // { "${getMajorVersion pkg}" = pkg; }) { } (unique cfg.java);
        javaEnvVariable = mapAttrs' (version: pkg: nameValuePair "JAVA_HOME_${version}" "${pkg.home}") javaPkgs;
        javaAliases = mapAttrs' (version: pkg: nameValuePair "java_${version}" "${getExe pkg}") javaPkgs;
        javaRuntimeEntries = mapAttrs' (version: pkg: nameValuePair "${cfg.root}/java-${version}" { source = pkg.home; }) javaPkgs;

        scalaPkgs = foldl' (acc: pkg: acc // { "${getMajorMinorVersion pkg}" = pkg; }) { } (unique cfg.scala);
        scalaAliases = mapAttrs' (version: pkg: nameValuePair "scala_${version}" ''${getExe' pkg "scala"}'') scalaPkgs;
        scalaRuntimeEntries = mapAttrs' (version: pkg: nameValuePair "${cfg.root}/scala-${version}" { source = pkg; }) scalaPkgs;
      in
      {
        file = javaRuntimeEntries // scalaRuntimeEntries;
        shellAliases = javaAliases // scalaAliases;
        sessionVariables = javaEnvVariable;
      };
  };
}
