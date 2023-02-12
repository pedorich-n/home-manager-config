{ pkgs, pkgs-unstable, lib, config, ... }:
with lib;
let
  cfg = config.custom.development.environments;

  # java-17 = pkgs-unstable.temurin-bin-17.overrideAttrs (_: { meta.priority = -10; }); # TODO: try this out
  java-17-default = pkgs-unstable.jdk17;
in
{

  ###### interface
  options = {
    custom.development.environments = {
      enable = mkEnableOption "Development Environments";

      jdk = mkOption {
        type = types.package;
        default = java-17-default;
        description = "JDK to use";
      };

      scala = {
        enable = mkEnableOption "Scala";
        version = mkOption {
          type = types.enum [ "2.10" "2.11" "2.12" "2.13" ];
          default = "2.13";
          description = "Major Scala 2.X version to install";
        };
      };

      python.enable = mkEnableOption "Python";

      rust.enable = mkEnableOption "Rust";
    };
  };


  ###### implementation
  config =
    let
      scala-pkg = pkgs.scala.override { majorVersion = cfg.scala.version; jre = cfg.jdk; };
    in
    mkIf cfg.enable {
      home.packages = [ cfg.jdk ] ++
        lists.optional cfg.scala.enable (with pkgs;[
          scala-pkg
          (coursier.override { jre = cfg.jdk; })
          (sbt.override { jre = cfg.jdk; })
          (jetbrains.idea-community.override { inherit (cfg) jdk; })
        ]) ++
        lists.optional cfg.python.enable (with pkgs; [
          (jetbrains.pycharm-community.override { inherit (cfg) jdk; })
        ]) ++
        lists.optional cfg.rust.enable (with pkgs;[
          rustup
        ]);

      custom.programs.pyenv = mkIf cfg.python.enable { enable = true; };

      home.file.".sdks/scala-${cfg.scala.version}".source = scala-pkg;
      # TODO: Alias to java-${version} in .sdks. 
      # Requires to write a function to extract major version from semver, because java.version returns something like 11.0.6
    };
}
