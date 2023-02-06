{ pkgs }:
let
  libs = with pkgs; [
    zlib
    libffi
    readline
    bzip2
    openssl
    sqlite
    ncurses
    gdbm
    xz
    expat
    tcl
    tk
  ];

  openssl-dev = pkgs.lib.getDev pkgs.openssl;
in
pkgs.mkShell {
  name = "peynv builder";
  nativeBuildInputs = (with pkgs; [
    gcc
    gnumake
  ]);

  CPPFLAGS = builtins.concatStringsSep " " (map (p: "-I${pkgs.lib.getDev p}/include") libs);
  LDFLAGS = builtins.concatStringsSep " " (map (p: "-L${pkgs.lib.getLib p}/lib") libs);
  CFLAGS = "-I${openssl-dev}/inlcude";
  CONFIGURE_OPTS = "-with-openssl=${openssl-dev}";
}
