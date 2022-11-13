{ stdenv, lib, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "zsh-snap";
  version = "a80c0762b08699c1ab8d8a26e2db8141bab995e7";

  src = fetchFromGitHub {
    owner = "marlonrichert";
    repo = "zsh-snap";
    rev = version;
    sha256 = "sha256-KS3jC/HJKvnaHU9pzwcI+K6njaNIAO/7brmNu2nEquw=";
  };

  strictDeps = true;
  dontConfigure = true;
  dontBuild = true;
  dontPatch = true;

  installPhase = ''
    mkdir -p $out
    cp -r $src/* $out/
  '';

  meta = with lib; {
    description = "Znap! Fast, easy-to-use tools for Zsh dotfiles & plugins, plus git repos";
    homepage = "https://github.com/marlonrichert/zsh-snap";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
