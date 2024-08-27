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
      zsh.keychainIdentities = [ "id_main" gpgKey ];
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
  };

  services.gpg-agent.pinentryPackage = pkgs.pinentry-curses;

  home.packages = with pkgs; [
    pinentry-curses
    wslu
  ];
}
