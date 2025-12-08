{ pkgs, ... }:
let
  python = pkgs.python3.withPackages (pp: [
    pp.pytz
    pp.tzlocal
  ]);

in
pkgs.symlinkJoin {
  name = "cqlsh";
  paths = [ pkgs.cassandra ];
  nativeBuildInputs = [ pkgs.makeBinaryWrapper ];

  postBuild = ''
    wrapProgram $out/bin/cqlsh --prefix PATH : ${python}/bin
  '';
}
