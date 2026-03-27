{
  otto-theme,
  stdenv,
  ...
}:
stdenv.mkDerivation {
  pname = "otto-theme";
  src = otto-theme;
  version = otto-theme.shortRev;

  dontBuild = true;
  dontPatch = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/{plasma/desktoptheme,plasma/look-and-feel,color-schemes,aurorae/themes,konsole,Kvantum}

    cp -r "$src/color-schemes/"*.colors $out/share/color-schemes/
    cp -r "$src/Otto/" $out/share/plasma/desktoptheme/
    cp -r "$src/look-and-feel/Otto" $out/share/plasma/look-and-feel/
    cp -r "$src/aurorae/Otto" $out/share/aurorae/themes/
    cp -r "$src/konsole/"*.colorscheme $out/share/konsole/
    cp -r "$src/kvantum/Otto" $out/share/Kvantum/

    runHook postInstall
  '';

  postInstall = ''
    substituteInPlace $out/share/Kvantum/Otto/Otto.kvconfig \
      --replace-fail 'transparent_dolphin_view=true' 'transparent_dolphin_view=false'
  '';
}
