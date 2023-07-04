{ pkgs, lib, config, ... }:
with lib;
let
  cfg = config.custom.programs.vscode-remote;
  cfgVsCode = config.programs.vscode;

  jsonFormat = pkgs.formats.json { };

  baseFolder = "~/.vscode-server";
  userSettingsPath = "${baseFolder}/data/Machine/settings.json";

  settingsToUpdate = {
    "editor.fontSize" = 13;
    "window.zoomLevel" = 0.3;
  };
in
{
  ###### interface
  options = {
    custom.programs.vscode-remote = {
      enable = mkEnableOption "VS Code Remote";
    };
  };


  ###### implementation
  config = mkIf cfg.enable {
    home.file = mkMerge [
      # TODO: extensions?
      (mkIf (cfgVsCode.userSettings != { }) {
        ${userSettingsPath}.source = jsonFormat.generate "vscode-server-user-settings" (cfgVsCode.userSettings // settingsToUpdate);
      })
    ];
  };
}
