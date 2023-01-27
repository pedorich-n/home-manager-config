args @ { pkgs, ... }:
{
  imports = [
    (import ./common.nix (args // { username = "mykytapedorich"; }))
    (import ../modules/programs/zsh (args // { identities = [ "work/paidy" ]; }))
    ../modules/programs/git.nix
    ../modules/packages/common.nix
  ];

  home.packages = with pkgs; [
    saml2aws
  ];

  programs = {
    git = {
      userEmail = "pedorich.n@gmail.com";
      signing.key = "900C2FE784D62F8C";
    };
  };
}
