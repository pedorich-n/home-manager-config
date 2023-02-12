{ pkgs, lib, config, ... }:
with lib;
let
  cfg = config.custom.programs.direnv;

  # TODO: share this code between pyenv and direnv somehow?
  shellIntegrationsModule = types.submodule {
    options = {
      bash.enable = mkEnableOption "bash";
      zsh.enable = mkEnableOption "zsh";
    };
  };
in
{
  ###### interface
  options = {
    custom.programs.direnv = {
      enable = mkEnableOption "direnv";

      shellIntegrations = mkOption {
        type = shellIntegrationsModule;
        default = { };
        description = "Enable shell integrations";
      };
    };
  };


  ###### implementation
  config = mkIf cfg.enable {

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;

      enableZshIntegration = cfg.shellIntegrations.zsh.enable;
      enableBashIntegration = cfg.shellIntegrations.bash.enable;
    };
  };
}
