{
  otto-light-theme,
  stdenv,
  ...
}:
stdenv.mkDerivation {
  pname = "otto-light-theme";
  src = otto-light-theme;
  version = otto-light-theme.shortRev;

  dontBuild = true;
  dontPatch = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/{plasma/desktoptheme,plasma/look-and-feel,color-schemes,aurorae/themes,konsole,Kvantum}

    cp -r "$src/Color-schemes/"*.colors $out/share/color-schemes/
    cp -r "$src/plasma/Otto-Light" $out/share/plasma/desktoptheme/
    cp -r "$src/look-and-feel/Otto-Light" $out/share/plasma/look-and-feel/
    cp -r "$src/aurorae/Otto-Light" $out/share/aurorae/themes/
    cp -r "$src/konsole/"*.colorscheme $out/share/konsole/
    cp -r "$src/Kvantum/Otto-Light" $out/share/Kvantum/

    runHook postInstall
  '';

  postInstall = ''
    substituteInPlace $out/share/Kvantum/Otto-Light/Otto-Light.kvconfig \
      --replace-fail 'transparent_dolphin_view=true' 'transparent_dolphin_view=false'
  '';
}
