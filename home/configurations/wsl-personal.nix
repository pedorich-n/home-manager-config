{ pkgs-unstable, ... }:
{
  custom = {
    base.linux = {
      username = "pedorich_n";
      installCommonApps = true;
      genericLinux = true;
      installNix = {
        enable = true;
        package = pkgs-unstable.nix;
      };
    };

    programs = {
      zsh = {
        enable = true;
        keychainIdentities = [ "id_main" ];
      };

      git = {
        enable = true;
        userEmail = "pedorich.n@gmail.com";
        # signingKey = "ADC7FB37D4DF4CE2";
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
}
