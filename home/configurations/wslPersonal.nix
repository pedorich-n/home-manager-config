{ pkgs, lib, ... }:
let
  gpgKey = "ADC7FB37D4DF4CE2";
in
{
  imports = [ ./commonStandalone.nix ];

  home.username = "pedorich_n";

  custom = {
    aliases.hms.configName = "wslPersonal";
    runtimes.enable = true;
    programs = {
      gpg.enable = true;
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

    # See https://1password.community/discussion/comment/673567/#Comment_673567
    #LINK - packages/wsl-1password-cli/default.nix
    zsh.initExtra = lib.mkOrder 1200 ''
      if command -v op &>/dev/null; then
       eval "$(op completion zsh 2>/dev/null || true)"
       compdef _op op
      fi
    '';
  };

  home.packages = with pkgs; [
    pinentry-curses
    wslu
    wsl-1password-cli
  ];
}
