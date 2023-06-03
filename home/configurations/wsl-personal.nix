{ pkgs, ... }:
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
      rtx = {
        enable = true;
        shellIntegrations.zsh.enable = true;
        config = {
          tools = {
            "python" = [ "3.11" ];
          };
        };
      };

      gpg.enable = true;

      zsh = {
        enable = true;
        keychainIdentities = [ "id_main" gpgKey ];
      };
    };
  };

  programs = {
    git = {
      enable = true;
      signing.key = gpgKey;
    };
  };

  home.packages = with pkgs; [
    python311Packages.black
    wslu
  ];
}
