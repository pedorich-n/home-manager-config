{ pkgs, lib, config, ... }:
let
  cfg = config.custom.programs.nh;
in
{
  ###### interface
  options = with lib; {
    custom.programs.nh = {
      enable = mkEnableOption "nh";

      flakeRef = mkOption {
        type = with types; either str path;
        description = ''
          Full path to this flake configuration on system. Should not be `flake`!
        '';
        example = literalExpression "/home/user/.config.nix";
      };

      configName = mkOption {
        type = with types; nullOr str;
        default = null;
        description = ''
          Optional configuration name to use when switching configuration
        '';
        example = literalExpression "username@hostname";
      };

      aliases = {
        homeManager = mkEnableOption "Home Manager Switch Alias";
      };
    };
  };


  ###### implementation
  config = lib.mkIf cfg.enable {
    home = {
      packages = [ pkgs.nh ];

      sessionVariables = {
        FLAKE = builtins.toString cfg.flakeRef;
      };

      shellAliases = lib.mkMerge [
        (lib.mkIf cfg.aliases.homeManager {
          hms = "nh home switch" + lib.optionalString (cfg.configName != null) " --configuration ${cfg.configName}";
        })
      ];

    };
  };
}
