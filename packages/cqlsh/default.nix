{ pkgs, ... }:
pkgs.symlinkJoin {
  name = "cqlsh";
  paths = [ pkgs.cassandra ];
  nativeBuildInputs = [ pkgs.makeBinaryWrapper ];

  postBuild = ''
    wrapProgram $out/bin/cqlsh --prefix PATH : ${pkgs.python27}/bin
  '';
}
