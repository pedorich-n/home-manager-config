args @ { pkgs, ... }:
let
  args_updated = args // {
    username = "mykytapedorich";
    identities = [ "work/paidy" ];
  };
in
{
  imports = [
    (import ./common-linux.nix (args_updated))
    (import ../modules/programs/zsh (args_updated))
    ../modules/programs/git.nix
    ../modules/packages/common.nix
    ../modules/packages/scala.nix
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
