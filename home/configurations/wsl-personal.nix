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
      gpg = {
        enable = true;
        pinentryFlavor = "curses";
      };
      jdk.enable = true;
      rust.enable = true;
      scala.enable = true;
      vscode-remote.enable = true;
      zsh.keychainIdentities = [ "id_main" gpgKey ];
    };
  };

  programs = {
    git.signing = {
      key = gpgKey;
      signByDefault = true;
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
    pinentry-curses
    python3Packages.black
    wslu
  ];
}
