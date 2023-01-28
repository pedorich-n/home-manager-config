{ pkgs, pkgs-unstable, ... }:
let
  mkCleanupOverlay = import ../overlays/post_fixup_cleanup.nix;
in
{
  home.packages =
    # Need to cleanup the $out directories, to avoid collissions
    (with (pkgs-unstable.extend (mkCleanupOverlay "temurin-bin-17" [ "NOTICE" "release" ])); [ temurin-bin-17 ]) ++
    (with (pkgs.extend (mkCleanupOverlay "scala" [ "LICENSE" "NOTICE" ]));
    [
      (coursier.override { jre = pkgs-unstable.temurin-bin-17; })
      (scala.override { majorVersion = "2.13"; jre = pkgs-unstable.temurin-bin-17; })
      (sbt.override { jre = pkgs-unstable.temurin-bin-17; })
      # (jetbrains.idea-community.override { jdk = pkgs-unstable.temurin-bin-17; })
    ]);
}
