{ lib, config, customLib, pkgs, ... }:
with lib;
let
  cfg = config.custom.programs.zsh-snap;

  sourceModule = types.submodule {
    options = {
      repo = mkOption {
        type = types.str;
        description = "Github repo in form of 'organization/repository'";
      };

      path = mkOption {
        type = with types; nullOr str;
        default = null;
        description = "Optional subfolder(s) path";
      };
    };
  };

  fpathModule = types.submodule {
    options = {
      name = mkOption {
        type = types.str;
        description = "Fpath function name";
      };

      command = mkOption {
        type = types.str;
        description = "Fpath function command";
      };
    };
  };

  znapSourceFor = source: "znap source ${source.repo} ${builtins.toString source.path}";
  znapFpathFor = fpath: "znap fpath ${fpath.name} '${fpath.command}'";
in
{
  ###### interface
  options = {
    custom.programs.zsh-snap = {
      enable = mkEnableOption "zsh-snap";

      reposDir = mkOption {
        type = types.str;
        default = "$HOME/.zsh-plugins";
        description = "Custom repos dir";
      };

      sources = mkOption {
        type = types.listOf sourceModule;
        default = [ ];
        description = "Optional list of sources to install and manage by zsh-snap";
      };

      fpaths = mkOption {
        type = types.listOf fpathModule;
        default = [ ];
        description = "Optional list of fpath functions";
      };
    };
  };


  ###### implementation
  config = mkIf cfg.enable {
    home.packages = [ pkgs.zsh-snap ];

    programs.zsh.initExtraBeforeCompInit = with builtins; with customLib;
      ''
        zstyle ':znap:*' repos-dir ${cfg.reposDir}
        source ${pkgs.zsh-snap}/znap.zsh

        ${strings.optionalString (nonEmpty cfg.sources) (concatLines (map znapSourceFor cfg.sources))}
        ${strings.optionalString (nonEmpty cfg.fpaths) (concatLines (map znapFpathFor cfg.fpaths))}
      '';
  };
}
