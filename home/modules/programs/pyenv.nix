{ pkgs, pyenv-flake, lib, config, ... }:
with lib;
let
  cfg = config.custom.programs.pyenv;

  shellIntegrationsModule = types.submodule ({ config, ... }: {
    options = {
      bash.enable = mkEnableOption "bash";
      zsh.enable = mkEnableOption "zsh";
    };
  });

  envsFor = cfg: shell:
    if cfg.shellIntegrations.${shell}.enable
    then ''
      export PYENV_ROOT="$HOME/${cfg.root}"
      export PATH="$PYENV_ROOT/bin:$PATH"
      eval "$(pyenv init --path)"
    ''
    else "";
in
{

  ###### interface

  options = {
    custom.programs.pyenv = {
      enable = mkEnableOption "pyenv";

      root = mkOption {
        type = types.str;
        default = ".pyenv";
        description = "Path (under $HOME) where Pyenv and its shims will be stored";
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
    home.file.${cfg.root} = {
      recursive = true;
      source = pkgs.fetchFromGitHub {
        owner = "pyenv";
        repo = "pyenv";
        rev = pyenv-flake.rev;
        sha256 = pyenv-flake.narHash;
      };
    };

    programs.bash.profileExtra = envsFor cfg "bash";
    programs.zsh.envExtra = envsFor cfg "zsh";
  };
}
