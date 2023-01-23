args @ { ... }:
{
  imports = [
    (import ./common.nix (args // { username = "mykytapedorich"; }))
    ../modules/programs/zsh
    ../modules/programs/git.nix
    ../modules/packages/common.nix
  ];

  programs = {
    git = {
      userEmail = "pedorich.n@gmail.com";
      signing.key = "900C2FE784D62F8C";
    };
    zsh.initExtraBeforeCompInit = "zstyle :omz:plugins:keychain identities work/paidy\n";
  };
}
