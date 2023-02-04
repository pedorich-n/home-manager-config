{ pkgs, pkgs-unstable, ... }:
let
  mkCleanupOverlay = import ../overlays/post-fixup-cleanup.nix;

  # Need to cleanup the $out directories, to avoid collissions
  pkgs-with-overlay = import pkgs {
    overlays = [ (mkCleanupOverlay "scala" [ "LICENSE" "NOTICE" ]) ];
  };
  pkgs-unstable-with-overlay = import pkgs-unstable {
    overlays = [ (mkCleanupOverlay "temurin-bin-17" [ "NOTICE" "release" ]) ];
  };

  temurin-17 = pkgs-unstable-with-overlay.temurin-bin-17;
  scala-2-13 = (pkgs-with-overlay.scala.override { majorVersion = "2.13"; jre = temurin-17; });
in
{
  home.packages =
    temurin-17 ++
    scala-2-13 ++
    (with pkgs-with-overlay;
    [
      (coursier.override { jre = temurin-17; })
      (sbt.override { jre = temurin-17; })
      (jetbrains.idea-community.override { jdk = temurin-17; })
    ]);

  home.file."sdks/scala_2_13".source = scala-2-13;
}
