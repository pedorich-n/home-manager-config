{ pkgs, ... }:
let
  sources = pkgs.callPackage ./_sources/generated.nix { };
in
pkgs.stdenv.mkDerivation {
  inherit (sources.localsend) pname version src;

  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [ pkgs.dpkg ];

  installPhase = ''
    mkdir -p $out/{bin,share}

    exe=$out/bin/localsend_app

    cp -r usr/share/applications/ $out/share/
    cp -r usr/share/icons/ $out/share/

    cp -r usr/share/localsend_app/localsend_app $out/bin/localsend_app

    cp -r usr/share/localsend_app/lib/ $out/bin/
    cp -r usr/share/localsend_app/data/ $out/bin/


    substituteInPlace $out/share/applications/localsend_app.desktop \
      --replace-fail localsend_app $exe
  '';


  meta = {
    mainProgram = "localsend_app";
  };
}
