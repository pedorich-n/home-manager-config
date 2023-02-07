{ pkgs, pyenv-flake, lib, config, ... }:
with lib;
let
  cfg = config.custom.programs.pyenv;

  shellIntegrationsModule = types.submodule ({
    options = {
      bash.enable = mkEnableOption "bash";
      zsh.enable = mkEnableOption "zsh";
    };
  });

  envsFor = cfg: shell:
    strings.optionalString cfg.shellIntegrations.${shell}.enable ''
      export PYENV_ROOT="$HOME/${cfg.root}"
      export PATH="$PYENV_ROOT/bin:$PATH"
      eval "$(pyenv init --path)"
    '';
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

    home.shellAliases = {
      # "nixpkgs" has to be the same as input name in flake.nix
      pyenv-build = "nix develop nixpkgs#python311"; 
    };

    programs.bash.profileExtra = envsFor cfg "bash";
    programs.zsh.envExtra = envsFor cfg "zsh";
  };
}
