{ pkgs, lib, config, customLib, ... }:
with lib;
let
  cfg = config.custom.programs.ripgrep;
in
{
  ###### interface
  options = {
    custom.programs.ripgrep = {
      enable = mkEnableOption "Ripgrep";

      package = mkOption {
        type = types.package;
        default = pkgs.ripgrep;
      };

      config = {
        location = mkOption {
          type = types.str;
          default = "${config.xdg.configHome}/ripgrep/ripgreprc";
          description = "Path to config location (Under $HOME)";
        };

        lines = mkOption {
          type = types.listOf types.str;
          default = [ ];
          example = [ "--max-columns=150" "--max-columns-preview" ];
          description = "List of default shell arguments to pass";
        };
      };
    };
  };


  ###### implementation
  config = mkIf cfg.enable {
    home = {
      packages = [ cfg.package ];

      file.${cfg.config.location} =
        mkIf (customLib.nonEmpty cfg.config.lines) { text = (builtins.concatStringsSep "\n" cfg.config.lines) + "\n"; };

      sessionVariables = {
        "RIPGREP_CONFIG_PATH" = cfg.config.location;
      };
    };
  };
}
