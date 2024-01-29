{ pkgs, ... }:
let
  gpgKey = "ADC7FB37D4DF4CE2";
in
{
  imports = [ ./common-standalone.nix ];

  home.username = "pedorich_n";

  custom = {
    programs = {
      gpg = {
        enable = true;
        pinentryFlavor = "curses";
      };
      jdk.enable = true;
      nh.configName = "wslPersonal";
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

    mise = {
      enable = true;
      globalConfig = {
        tools = {
          "python" = [ "3.11" ];
        };
      };
      settings = {
        experimental = true;
      };
    };
  };

  home.packages = with pkgs; [
    pinentry-curses
    python3Packages.black
    wslu
  ];
}
