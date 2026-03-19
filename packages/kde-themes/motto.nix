{
  motto-plasma-theme,
  stdenv,
  ...
}:
stdenv.mkDerivation {
  name = "motto-plasma-theme";
  src = motto-plasma-theme;

  dontBuild = true;
  dontPatch = true;

  installPhase = ''
    mkdir -p $out/share/plasma/desktoptheme/
    mkdir -p $out/share/plasma/look-and-feel
    mkdir -p $out/share/color-schemes
    mkdir -p $out/share/aurorae/themes
    mkdir -p $out/share/sddm/themes

    mkdir -p $out/misc/kvantum/
    mkdir -p $out/misc/gtk/


    cp -r "$src/Motto Color Schemes/"*.colors $out/share/color-schemes/
    cp -r "$src/Motto Global Themes/Motto-Dark-Global-6/" $out/share/plasma/look-and-feel/
    cp -r "$src/Motto Plasma Themes/Motto-Dark-Plasma/" $out/share/plasma/desktoptheme/
    cp -r "$src/Motto Window Decorations/Motto-Dark-Aurorae-6" $out/share/aurorae/themes/
    cp -r "$src/Motto Window Decorations/Motto-Dark-Blur-Aurorae-6" $out/share/aurorae/themes/

    cp -r "$src/Motto GTK Themes/Motto-Dark-GTK/" $out/misc/gtk/
    cp -r "$src/Motto Kvantum Themes/Motto-Dark-Kvantum/" $out/misc/kvantum/
  '';
}
