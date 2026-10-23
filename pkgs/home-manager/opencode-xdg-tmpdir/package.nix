{
  opencode,
  symlinkJoin,
  makeWrapper,
}:
symlinkJoin {
  pname = "opencode-xdg-tmpdir";
  version = opencode.version;

  paths = [
    opencode
  ];

  nativeBuildInputs = [
    makeWrapper
  ];

  postBuild = ''
    wrapProgram "${placeholder "out"}/bin/opencode" \
      --run 'export TMPDIR="''${XDG_RUNTIME_DIR:-/tmp}"'
  '';
}
