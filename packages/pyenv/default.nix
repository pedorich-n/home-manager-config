{ stdenvNoCC, lib, inputs, makeWrapper }:
stdenvNoCC.mkDerivation rec {
  pname = "pyenv";
  version = inputs.pyenv-source.shortRev;

  src = inputs.pyenv-source;

  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out
    rm LICENSE *.md Dockerfile
    cp -r * $out
  '';

  fixupPhase = ''
    wrapProgram $out/bin/pyenv \
    --run 'export PYENV_ROOT="''${PYENV_ROOT:-$HOME/.pyenv}"' \
    --run 'mkdir -p $PYENV_ROOT'
  '';

  meta = with lib; {
    description = "Simple Python version management";
    homepage = "https://github.com/pyenv/pyenv";
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
