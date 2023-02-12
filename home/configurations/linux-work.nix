{ pkgs, ... }:
{
  imports = [
    ./common-linux.nix
    ../modules/packages/common.nix
    ../modules/packages/development.nix
  ];

  custom = {
    home-linux = {
      username = "mykytapedorich";
    };

    programs = {
      zsh = {
        enable = true;
        keychainIdentities = [ "work/paidy" ];
      };

      git = {
        enable = true;
        userEmail = "pedorich.n@gmail.com";
        signingKey = "900C2FE784D62F8C";
      };

      direnv = {
        enable = true;
        shellIntegrations = {
          # bash.enable = true;
          zsh.enable = true;
        };
      };

      pyenv = {
        enable = true;
        shellIntegrations = {
          # bash.enable = true;
          zsh.enable = true;
        };
      };

      vim.enable = true;
      htop.enable = true;
    };
  };

  programs = {
    bash.enable = true; # To set Home Manager's ENVs vars in .profile 
  };

  home.packages = with pkgs; [
    barrier
    saml2aws
    ulauncher
    # touchegg ??
  ];
}
