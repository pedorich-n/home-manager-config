{ ... }:
{
  imports = [
    ./common-linux.nix
    ../modules/programs/zsh
    ../modules/programs/git.nix
    ../modules/packages/common.nix
    ../modules/programs/pyenv.nix
    ../modules/programs/zsh-snap.nix
    ../modules/programs/vim.nix
  ];

  custom = {
    home-linux = {
      username = "pedorich_n";
    };

    programs = {
      pyenv = {
        enable = true;
        shellIntegrations = {
          # bash.enable = true;
          zsh.enable = true;
        };
      };

      zsh = {
        enable = true;
        keychainIdentities = [ "id_main" ];
      };

      vim.enable = true;
    };
  };

  programs = {
    git = {
      userEmail = "pedorich.n@gmail.com";
      signing.key = "ADC7FB37D4DF4CE2";
    };
  };
}
