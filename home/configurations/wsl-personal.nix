args @ { ... }:
{
  imports = [
    (import ./common.nix (args // { username = "pedorich_n"; }))
    (import ../modules/programs/zsh (args // { identities = [ "id_main" ]; }))
    ../modules/programs/git.nix
    ../modules/packages/common.nix
  ];

  programs = {
    git = {
      userEmail = "pedorich.n@gmail.com";
      signing.key = "ADC7FB37D4DF4CE2";
    };
  };
}
