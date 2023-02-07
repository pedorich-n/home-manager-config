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
    ../modules/packages/development.nix
    ../modules/programs/pyenv.nix
  ];

  home.packages = with pkgs; [
    saml2aws
    ulauncher
  ];

  custom.programs = {
    pyenv = {
      enable = true;
      shellIntegrations = {
        bash.enable = true;
        zsh.enable = true;
      };
    };
  };

  programs = {
    git = {
      userEmail = "pedorich.n@gmail.com";
      signing.key = "900C2FE784D62F8C";
    };
    bash.enable = true; # To set Home Manager's ENVs vars in .profile 
  };
}
