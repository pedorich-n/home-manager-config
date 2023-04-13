{ pkgs, lib, config, ... }:
with lib;
let
  cfg = config.custom.programs.pyenv;

  shellIntegrationsModule = types.submodule {
    options = {
      bash.enable = mkEnableOption "bash";
      zsh.enable = mkEnableOption "zsh";
    };
  };

  envsFor = cfg: shell:
    strings.optionalString cfg.shellIntegrations.${shell}.enable (mkAfter ''
      export PYENV_ROOT="${cfg.root}"
      export PATH="$PYENV_ROOT/bin:$PATH"
    '');

  initFor = cfg: shell:
    strings.optionalString cfg.shellIntegrations.${shell}.enable (mkAfter ''
      eval "$(${pkgs.pyenv}/bin/pyenv init -)"
    '');
in
{
  ###### interface
  options = {
    custom.programs.pyenv = {
      enable = mkEnableOption "pyenv";

      root = mkOption {
        type = types.str;
        default = "$HOME/.pyenv";
        description = "Path where Pyenv will store its shims";
      };

      shellIntegrations = mkOption {
        type = shellIntegrationsModule;
        default = { };
        description = "Enable shell integrations";
      };
    };
  };


  ###### implementation
  config = mkIf cfg.enable {
    home = {
      packages = [ pkgs.pyenv ];
      shellAliases = {
        # "nixpkgs" has to be the same as input name in flake.nix
        pyenv-build = "nix develop nixpkgs#python311Full";
      };
    };

    programs.bash = {
      profileExtra = envsFor cfg "bash";
      bashrcExtra = initFor cfg "bash";
    };
    programs.zsh = {
      envExtra = envsFor cfg "zsh";
      initExtra = initFor cfg "zsh";
    };
  };
}
