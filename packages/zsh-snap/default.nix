{ stdenvNoCC, lib, inputs }:
stdenvNoCC.mkDerivation rec {
  pname = "zsh-snap";
  version = inputs.zsh-snap-source.shortRev;

  src = inputs.zsh-snap-source;

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  installPhase = ''
    mkdir -p $out
    rm LICENSE *.md 
    cp -r * $out
  '';

  meta = with lib; {
    description = "Znap! Fast, easy-to-use tools for Zsh dotfiles & plugins, plus git repos";
    homepage = "https://github.com/marlonrichert/zsh-snap";
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
