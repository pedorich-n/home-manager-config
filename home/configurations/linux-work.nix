{ pkgs, ... }:
let
  gpgKey = "900C2FE784D62F8C";
in
{
  imports = [ ./common-linux.nix ];

  home.username = "mykytapedorich";

  custom = {
    hm.name = "linuxWork";

    development.environments = {
      jdk.enable = true;

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
        jdk = {
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
    vscode.enable = true;

    git = {
      enable = true;
      signing.key = gpgKey;
    };
  };

  home.packages = with pkgs; [
    barrier
    saml2aws
    sublime4
  ];
}
