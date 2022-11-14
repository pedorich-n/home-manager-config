{ ... }:
{
  imports = [
    ./common.nix
    ../modules/programs/zsh
    ../modules/programs/git.nix
    ../modules/packages/common.nix
  ];

  programs = {
    git = {
      userEmail = "pedorich.n@gmail.com";
      signing = {
        key = "ADC7FB37D4DF4CE2";
        signByDefault = false;
      };
    };

    zsh.initExtra = "\n\nzstyle :omz:plugins:keychain identities id_main";
  };
}
