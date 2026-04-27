{
  zsh-tab-title,
  stdenvNoCC,
  lib,
}:
stdenvNoCC.mkDerivation {
  pname = "zsh-tab-title";
  version = zsh-tab-title.shortRev;
  src = lib.cleanSource zsh-tab-title;

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    dir="$out/share/zsh/plugins/zsh-tab-title"
    mkdir -p $dir
    cp zsh-tab-title.plugin.zsh $dir/zsh-tab-title.plugin.zsh

    runHook postInstall
  '';
}
