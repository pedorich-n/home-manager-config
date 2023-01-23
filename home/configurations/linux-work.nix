{ custom-params, ... }:
{
  imports = [
    ./common.nix
    ../modules/programs/zsh
    ../modules/programs/git.nix
    ../modules/packages/common.nix
  ];

  programs = {
    zsh.initExtra = "\n\nzstyle :omz:plugins:keychain identities work/paidy";
  };
}
