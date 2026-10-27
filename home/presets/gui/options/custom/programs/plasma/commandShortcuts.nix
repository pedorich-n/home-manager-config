{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.custom.programs.plasma.commandShortcuts;

  # KDE only treats a global shortcut as bound to a command when the .desktop
  # file carries X-KDE-GlobalAccel-CommandShortcut; without it the entry is
  # listed but the accelerator is ignored.
  mkDesktopFile =
    id: entry:
    pkgs.writeTextFile {
      name = "net.local.${id}.desktop";
      text = ''
        [Desktop Entry]
        Name=${entry.name}
        Exec=${entry.command}
        Type=Application
        NoDisplay=true
        StartupNotify=false
        X-KDE-GlobalAccel-CommandShortcut=true
      '';
    };
in
{
  options.custom.programs.plasma.commandShortcuts = lib.mkOption {
    type = lib.types.attrsOf (
      lib.types.submodule (
        { name, ... }:
        {
          options = {
            name = lib.mkOption {
              type = lib.types.nonEmptyStr;
              default = name;
              description = ''
                Label shown for the entry in KDE's shortcut settings.

                Defaults to the attribute name.
              '';
            };

            command = lib.mkOption {
              type = lib.types.nonEmptyStr;
              description = ''
                Command the shortcut runs, written verbatim to `Exec` in the
                generated `.desktop` file.
              '';
            };

            shortcut = lib.mkOption {
              type =
                with lib.types;
                oneOf [
                  nonEmptyStr
                  (nonEmptyListOf nonEmptyStr)
                ];
              description = ''
                Key combination that invokes the command. A list binds several
                combinations to the same command.
              '';
            };
          };
        }
      )
    );

    default = { };
    example = lib.literalExpression ''
      {
        "1password" = {
          name = "1Password Toggle";
          command = "1password --toggle";
          shortcut = "Ctrl+.";
        };
      }
    '';
    description = ''
      Commands exposed as global shortcuts on the Plasma desktop.

      Every entry is a `.desktop` file in
      `$XDG_DATA_HOME/applications/net.local.<name>.desktop` whose `Exec` runs
      `command`, plus a binding of `shortcut` to its `_launch` action. The
      `name` attribute is used as the desktop file's basename and is not shown
      in the UI; use the entry's `name` option for the visible label.

      Only applies when `programs.plasma.enable` is set.
    '';
  };

  config = lib.mkIf (config.programs.plasma.enable && cfg != { }) {
    xdg.dataFile = lib.mapAttrs' (
      id: entry:
      lib.nameValuePair "applications/net.local.${id}.desktop" {
        source = mkDesktopFile id entry;
      }
    ) cfg;

    programs.plasma.shortcuts = lib.mapAttrs' (
      id: entry:
      lib.nameValuePair "services/net.local.${id}.desktop" {
        _launch = entry.shortcut;
      }
    ) cfg;
  };
}
