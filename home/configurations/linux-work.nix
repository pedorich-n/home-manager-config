{ pkgs, ... }:
{
  imports = [
    ./common-linux.nix
    ../modules/programs/zsh
    ../modules/programs/git.nix
    ../modules/packages/common.nix
    ../modules/programs/pyenv.nix
    ../modules/programs/zsh-snap.nix
    ../modules/programs/vim.nix
    ../modules/packages/development.nix
  ];

  custom = {
    home-linux = {
      username = "mykytapedorich";
    };

    programs = {
      pyenv = {
        enable = true;
        shellIntegrations = {
          bash.enable = true;
          zsh.enable = true;
        };
      };

      zsh = {
        enable = true;
        keychainIdentities = [ "work/paidy" ];
      };

      vim.enable = true;
    };
  };

  programs = {
    git = {
      userEmail = "pedorich.n@gmail.com";
      signing.key = "900C2FE784D62F8C";
    };
    bash.enable = true; # To set Home Manager's ENVs vars in .profile 
  };

  home.packages = with pkgs; [
    barrier
    saml2aws
    ulauncher
    # touchegg ??
  ];
}
