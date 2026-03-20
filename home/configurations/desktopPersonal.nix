{
  pkgs,
  ...
}:
let
  gpgKey = "ADC7FB37D4DF4CE2";
in
{
  imports = [ ./commonStandalone.nix ];

  home.username = "nikita";

  custom = {
    selinux.enable = true;
    aliases.hms.configName = "desktopPersonal";
    programs = {
      gpg.enable = true;
      flameshot = {
        enable = true;
        package = null;
      };
      python = {
        enable = true;
        uv.enable = true;
      };
    };

    runtimes = {
      enable = true;
      java = [
        pkgs.jdk21
      ];
    };

    kde.themes = {
      enable = true;
      packages = [
        pkgs.kde-themes.otto
        pkgs.kde-themes.otto-light
        (pkgs.qogir-icon-theme.override { themeVariants = [ "default" ]; })
        pkgs.whitesur-cursors
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
        key = gpgKey;
        signByDefault = true;
      };
    };
    java.enable = true;
    keychain.keys = [
      gpgKey
    ];
    mise.enable = true;
    obsidian.enable = true;
    vscode.enable = true;
  };

  home.packages = with pkgs; [
    nerd-fonts.fira-code # IDE & terminal font
    opentofu
    telegram-desktop
    tofu-ls
  ];
}
