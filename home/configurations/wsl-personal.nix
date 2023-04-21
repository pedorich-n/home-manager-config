_:
let
  gpgKey = "ADC7FB37D4DF4CE2";
in
{
  imports = [ ./common-linux.nix ];

  home.username = "pedorich_n";

  custom = {
    hm.name = "wslPersonal";

    programs = {
      jdk.enable = true;
      rustup.enable = true;

      zsh = {
        enable = true;
        keychainIdentities = [ "id_main" gpgKey ];
      };

      pyenv = {
        enable = true;
        shellIntegrations.zsh.enable = true;
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
