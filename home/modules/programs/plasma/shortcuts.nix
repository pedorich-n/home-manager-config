{
  config,
  pkgs,
  lib,
  ...
}:
let
  # pkgs.makeDesktopItem is cumbersome to use in this case, so it's easier to just write the .desktop file directly.
  mkShortcutDekstop =
    {
      name,
      desktopName,
      exec,
    }:
    pkgs.writeTextFile {
      name = "net.local.${name}.desktop";
      text = ''
        [Desktop Entry]
        Name=${desktopName}
        Exec=${exec}
        Type=Application
        NoDisplay=true
        StartupNotify=false
        X-KDE-GlobalAccel-CommandShortcut=true
      '';
    };

in
{
  home.file = lib.mkIf config.programs.plasma.enable {
    ".local/share/applications/net.local.1password.desktop".source = mkShortcutDekstop {
      name = "1password";
      desktopName = "1Password Toggle";
      exec = "1password --toggle";
    };
  };

  programs.plasma.shortcuts = {
    "services/net.local.1password.desktop"._launch = "Ctrl+.";
  };
}
