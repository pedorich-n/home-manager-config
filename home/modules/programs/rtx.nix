{ pkgs, lib, config, customLib, ... }:
with lib;
let
  cfg = config.custom.programs.rtx;

  shellIntegrationsModule = types.submodule {
    options = {
      # bash.enable = mkEnableOption "bash";
      zsh.enable = mkEnableOption "zsh";
    };
  };

  configModule = types.submodule {
    options = {
      tools = mkOption {
        type = with types;  nullOr (attrsOf (oneOf [ (listOf str) str ]));
        default = { };
      };
    };
  };

  tomlFormat = pkgs.formats.toml { };

  package = pkgs.rtx;
in
{
  ###### interface
  options = {
    custom.programs.rtx = {
      enable = mkEnableOption "rtx";

      shellIntegrations = mkOption {
        type = shellIntegrationsModule;
        default = { };
        description = "Enable shell integrations";
      };

      config = mkOption {
        type = configModule;
        default = { };
      };
    };
  };


  ###### implementation
  config = mkIf cfg.enable {
    home = {
      packages = [ package ];

      activation = with lib.hm; {
        installRtxPackages = dag.entryAfter [ "linkGeneration" ] ''
          $DRY_RUN_CMD ${package}/bin/rtx install --install-missing ''${VERBOSE_ARG:---log-level=error} 
        '';
      };
    };

    programs.zsh.initExtra = strings.optionalString cfg.shellIntegrations.zsh.enable (mkAfter ''
      eval "$(${package}/bin/rtx activate zsh)"
    '');

    xdg.configFile."rtx/config.toml" =
      let
        tomlConfig = {
          tools = cfg.config.tools;
        };
      in
      mkIf (customLib.nonEmpty cfg.config) {
        source = tomlFormat.generate "rtx-config" tomlConfig;
      };
  };
}
