{
  pkgs,
  ...
}:
let
  gpgKey = "ADC7FB37D4DF4CE2";
in
{
  imports = [ ./commonStandalone.nix ];

  fonts.fontconfig.enable = true;

  custom = {
    selinux.enable = true;
    aliases.hms.configName = "desktopPersonal";
    programs = {
      gpg.enable = true;
      python = {
        enable = true;
        uv.enable = true;
      };
      plasma.themes.enable = true;
    };

    runtimes = {
      enable = true;
      java = [
        pkgs.jdk21
      ];
    };
  };

  programs = {
    git = {
      settings.user = {
        name = "Nikita Pedorich";
        email = "pedorich.n@gmail.com";
      };

      signing = {
        format = "openpgp";
        key = gpgKey;
        signByDefault = true;
      };
    };
    java = {
      enable = true;
      package = pkgs.jre;
    };
    keychain.keys = [
      "id_main"
      gpgKey
    ];
    mise.enable = true;
    obsidian.enable = true;
    plasma.enable = true;
    vscode.enable = true;
  };

  services = {
    easyeffects.enable = true;
  };

  home = {
    username = "nikita";

    packages = with pkgs; [
      jquake
      opentofu
      tofu-ls
    ];
  };
}
