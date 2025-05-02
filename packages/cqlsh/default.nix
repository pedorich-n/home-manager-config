{ pkgs, nixpkgs-cassandra, ... }:
let
  pkgs-cassandra = import nixpkgs-cassandra {
    inherit (pkgs) system;
  };
in
pkgs.symlinkJoin {
  name = "cqlsh";
  paths = [ pkgs-cassandra.cassandra_3_11 ];
  nativeBuildInputs = [ pkgs.makeBinaryWrapper ];

  postBuild = ''
    wrapProgram $out/bin/cqlsh --prefix PATH : ${pkgs.python27}/bin
  '';
}
