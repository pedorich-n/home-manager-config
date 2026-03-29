{
  pkgs,
  ...
}:
let
  sources = pkgs.callPackage ./_sources/generated.nix { };
in
pkgs.stdenv.mkDerivation {
  inherit (sources.zsh-tab-title) pname version src;

  dontUnpack = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    dir="$out/share/zsh/plugins/"
    mkdir -p $dir

    cp $src $dir/zsh-tab-title.plugin.zsh

    runHook postInstall
  '';
}
