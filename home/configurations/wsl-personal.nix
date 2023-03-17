_:
let
  gpgKey = "ADC7FB37D4DF4CE2";
in
{
  imports = [ ./common-linux.nix ];

  home.username = "pedorich_n";

  custom = {
    hm.name = "wslPersonal";

    development.environments = {
      jdk.enable = true;

      rust = {
        enable = true;
        version = "nightly";
      };

      python.enable = true;

      aliases = {
        jdk = {
          enable = true;
          name = "java-17";
        };
      };
    };

    programs = {
      zsh = {
        enable = true;
        keychainIdentities = [ "id_main" gpgKey ];
      };

      pyenv = {
        enable = true;
        shellIntegrations = {
          # bash.enable = true;
          zsh.enable = true;
        };
      };

      gpg.enable = true;
    };
  };

  programs = {
    htop.enable = true;
    direnv.enable = true;
    vim.enable = true;

    git = {
      enable = true;
      signing.key = gpgKey;
    };
  };
}
