{
  stdenvNoCC,
  ...
}:
stdenvNoCC.mkDerivation {
  name = "custom-wallpapers";
  src = ./pictures;

  dontBuild = true;
  dontPatch = true;
  dontFixup = true;

  installPhase = ''
    mkdir -p $out/share/wallpapers

    cp -r $src/* $out/share/wallpapers/
  '';
}
