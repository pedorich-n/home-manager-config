{ pkgs, ... }:
{
  custom = {
    base.linux = {
      username = "mykytapedorich";
      installCommonApps = true;
      genericLinux = true;
      installNix.enable = true;
    };

    development.environments = {
      scala = {
        enable = true;
        version = "2.13";
      };

      rust = {
        enable = true;
        version = "nightly";
      };

      python.enable = true;

      aliases = {
        scala = {
          enable = true;
          name = "scala-2.13";
        };
        java = {
          enable = true;
          name = "java-17";
        };
      };
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
