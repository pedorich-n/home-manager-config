{ pkgs, pkgs-unstable, ... }:
let
  gpgKey = "ADC7FB37D4DF4CE2";
in
{
  imports = [ ./common-linux.nix ];

  home.username = "mykytapedorich";

  custom = {
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
        keychainIdentities = [ "work/paidy" gpgKey ];
      };

      pyenv = {
        enable = true;
        shellIntegrations = {
          # bash.enable = true;
          zsh.enable = true;
        };
      };
    };
  };

  programs = {
    bash.enable = true; # To set Home Manager's ENVs vars in .profile 
    htop.enable = true;
    direnv.enable = true;
    vim.enable = true;

    git = {
      enable = true;
      signing = {
        key = gpgKey;
        signByDefault = true;
      };
    };
  };

  home.packages = with pkgs; [
    barrier
    saml2aws
    ulauncher
    # touchegg ??
  ];
}
