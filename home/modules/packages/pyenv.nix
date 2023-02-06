{ pkgs, pyenv-flake, ... }:
let
  paths = ''
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
  '';
in
{
  home.file.".pyenv" = {
    recursive = true;
    source = pkgs.fetchFromGitHub {
      owner = "pyenv";
      repo = "pyenv";
      rev = pyenv-flake.rev;
      sha256 = pyenv-flake.narHash;
    };
  };

  programs.bash.profileExtra = paths;
  programs.zsh.envExtra = paths;
}
