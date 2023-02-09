{ pkgs, pkgs-unstable, ... }:
let
  java-17 = pkgs-unstable.jdk17;
  scala-2-13 = pkgs.scala.override { majorVersion = "2.13"; jre = java-17; };
in
{
  home.packages =
    [
      java-17
      scala-2-13
    ] ++
    (with pkgs;
    [
      # Scala
      (coursier.override { jre = java-17; })
      (sbt.override { jre = java-17; })
      (jetbrains.idea-community.override { jdk = java-17; })
      # Python 
      (jetbrains.pycharm-community.override { jdk = java-17; })
      # Rust
      rustup
    ]);

  home.file.".sdks/scala-2-13".source = scala-2-13;
  home.file.".sdks/java-17".source = java-17;
}
