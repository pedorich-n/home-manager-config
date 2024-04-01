{ pkgs, lib, config, ... }:
with lib;
let
  cfg = config.custom.programs.nh;

  aliasesSubmodule = types.submodule {
    options = {
      homeManager = mkEnableOption "Home Manager Switch Alias";
    };
  };
in
{
  ###### interface
  options = {
    custom.programs.nh = {
      enable = mkEnableOption "nh";

      flakeRef = mkOption {
        type = with types; either str path;
        description = ''
          Full path to this flake configuration on system. Should not be `self`!
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

      aliases = mkOption {
        type = aliasesSubmodule;
        default = { };
      };
    };
  };


  ###### implementation
  config = mkIf cfg.enable {
    home = {
      packages = [ pkgs.nh ];

      sessionVariables = {
        FLAKE = builtins.toString cfg.flakeRef;
      };

      shellAliases = mkMerge [
        (mkIf cfg.aliases.homeManager {
          hms = "nh home switch" + optionalString (cfg.configName != null) " --configuration ${cfg.configName}";
        })
      ];

    };
  };
}
