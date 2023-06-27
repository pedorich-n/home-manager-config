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
      gpg.enable = true;
      jdk.enable = true;
      rust.enable = true;

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

    rtx = {
      enable = true;
      settings = {
        tools = {
          "python" = [ "3.11" ];
        };
      };
    };
  };

  home.packages = with pkgs; [
    python3Packages.black
    wslu
  ];
}
