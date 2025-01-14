{ config, lib, pkgs, ... }:
let
  cfg = config.custom.programs.flameshot;

  iniFormat = pkgs.formats.ini { };

  iniFile = iniFormat.generate "flameshot.ini" cfg.settings;
in
{
  options = {
    # Basically a copy of https://github.com/nix-community/home-manager/blob/fc52a210b/modules/services/flameshot.nix
    # But without the systemd service. Just the settings.
    custom.programs.flameshot = {
      enable = lib.mkEnableOption "Custom configs for Flameshot";

      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.flameshot;
      };

      settings = lib.mkOption {
        inherit (iniFormat) type;
        default = { };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];

    xdg.configFile = lib.mkIf (cfg.settings != { }) {
      "flameshot/flameshot.ini".source = iniFile;
    };
  };
}
