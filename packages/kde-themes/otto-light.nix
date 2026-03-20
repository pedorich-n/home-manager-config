{
  otto-light-theme,
  stdenv,
  ...
}:
stdenv.mkDerivation {
  name = "otto-light-theme";
  src = otto-light-theme;

  dontBuild = true;
  dontPatch = true;

  outputs = [
    "out"
    "link"
  ];

  installPhase = ''
    mkdir -p $out/share/{plasma/desktoptheme,plasma/look-and-feel,color-schemes,aurorae/themes}
    mkdir -p $link/{kvantum,konsole}

    cp -r "$src/Color-schemes/"*.colors $out/share/color-schemes/
    cp -r "$src/plasma/Otto-Light" $out/share/plasma/desktoptheme/
    cp -r "$src/look-and-feel/Otto-Light" $out/share/plasma/look-and-feel/
    cp -r "$src/aurorae/Otto-Light" $out/share/aurorae/themes/

    cp -r "$src/Kvantum/Otto-Light" $link/kvantum/
    cp -r "$src/konsole/"*.colorscheme $link/konsole/
  '';
}
