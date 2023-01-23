args @ { ... }:
{
  imports = [
    (import ./common.nix (args // { username = "pedorich_n"; }))
    ../modules/programs/zsh
    ../modules/programs/git.nix
    ../modules/packages/common.nix
  ];

  programs = {
    git = {
      userEmail = "pedorich.n@gmail.com";
      signing.key = "ADC7FB37D4DF4CE2";
    };
    zsh.initExtraBeforeCompInit = "zstyle :omz:plugins:keychain identities id_main\n";
  };

}
