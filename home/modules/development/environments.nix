{ pkgs, pkgs-unstable, lib, config, ... }:
with lib;
let
  cfg = config.custom.development.environments;

  aliasSubmoduleFor = name: types.submodule {
    options = {
      enable = mkEnableOption "Alias for ${name}";
      name = mkOption {
        type = types.str;
        description = "Folder name for the alias";
      };
    };
  };

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

      aliases = {
        root = mkOption {
          type = types.str;
          default = ".sdks";
          description = "Root folder for aliases (under $HOME)";
        };

        scala = mkOption { type = aliasSubmoduleFor "Scala"; };
        java = mkOption { type = aliasSubmoduleFor "Java"; };
      };
    };
  };


  ###### implementation
  config =
    let
      enable = cfg.enable || cfg.scala.enable || cfg.python.enable || cfg.rust.enable;

      scala = pkgs.scala.override { majorVersion = cfg.scala.version; jre = cfg.jdk; };

      scala-pkgs = lists.optionals cfg.scala.enable (with pkgs; [
        scala
        (coursier.override { jre = cfg.jdk; })
        (sbt.override { jre = cfg.jdk; })
        (jetbrains.idea-community.override { inherit (cfg) jdk; })
      ]);

      python-pkgs = lists.optionals cfg.python.enable (with pkgs; [
        (jetbrains.pycharm-community.override { inherit (cfg) jdk; })
      ]);

      rust-pkgs = lists.optionals cfg.rust.enable (with pkgs; [
        rustup
      ]);
    in
    mkIf enable {
      home.packages = [ cfg.jdk ] ++ scala-pkgs ++ python-pkgs ++ rust-pkgs;

      custom.programs.pyenv.enable = mkIf cfg.python.enable true;

      home.file = builtins.listToAttrs [
        (mkIf cfg.aliases.scala.enable { "${cfg.aliases.root}/${cfg.aliases.scala.name}".source = scala; })
        (mkIf cfg.aliases.java.enable { "${cfg.aliases.root}/${cfg.aliases.java.name}".source = cfg.jdk; })
      ];
    };
}
