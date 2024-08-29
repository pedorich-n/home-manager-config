{ pkgs, ... }:
let
  gpgKey = "ADC7FB37D4DF4CE2";
in
{
  imports = [ ./common-standalone.nix ];

  home.username = "pedorich_n";

  custom = {
    runtimes.enable = true;
    programs = {
      gpg.enable = true;
      nh.configName = "wslPersonal";
      python.enable = true;
      rust.enable = true;
      scala.enable = true;
    };
  };

  programs = {
    git = {
      userName = "Nikita Pedorich";
      userEmail = "pedorich.n@gmail.com";

      signing = {
        key = gpgKey;
        signByDefault = true;
      };
    };
    java.enable = true;
    keychain.keys = [ "id_main" gpgKey ];
  };

  home.packages = with pkgs; [
    pinentry-curses
    wslu
  ];
}
