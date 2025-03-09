{ config, lib, ... }:
let
  cfg = config.custom.aliases;
in
{
  options.custom.aliases = {
    enable = lib.mkEnableOption "Enable custom aliases";

    hm = {
      enable = lib.mkEnableOption "HomeManager alias";
    };

    hms = {
      enable = lib.mkEnableOption "Alias switching the HomeManager configuration";

      configName = lib.mkOption {
        type = lib.types.nonEmptyStr;
        description = "Name of the HomeManager config to switch to";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.shellAliases = lib.mkMerge [
      (lib.mkIf cfg.hm.enable {
        hm = "home-manager";
      })
      (lib.mkIf cfg.hms.enable {
        hms = "nh home switch --configuration ${cfg.hms.configName}";
      })
    ];
  };
}
