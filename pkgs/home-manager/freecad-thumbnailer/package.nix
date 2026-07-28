{
  freecad,
  runCommand,
  lib,
}:
runCommand "freecad-thumbnailer"
  {
    nativeBuildInputs = [ freecad ];
  }
  ''
    mkdir -p $out/bin $out/share/{icons/hicolor,thumbnailers,mime/packages}

    cp ${freecad}/bin/freecad-thumbnailer $out/bin/freecad-thumbnailer

    substituteInPlace $out/bin/freecad-thumbnailer \
      --replace-fail '"share/icons' '"${placeholder "out"}/share/icons'

    chmod +x $out/bin/freecad-thumbnailer

    cp ${freecad}/share/thumbnailers/FreeCAD.thumbnailer $out/share/thumbnailers/FreeCAD.thumbnailer
    substituteInPlace $out/share/thumbnailers/FreeCAD.thumbnailer \
      --replace-fail "${lib.getExe' freecad "freecad-thumbnailer"}" "$out/bin/freecad-thumbnailer"

    cp -r ${freecad}/share/icons/hicolor/* $out/share/icons/hicolor/
    cp -r ${freecad}/share/mime/packages/* $out/share/mime/packages/
  ''
