{ lib, config, customLib, zsh-snap, ... }:
with lib;
let
  cfg = config.custom.programs.zsh.snap;

  sourceModule = types.submodule {
    options = {
      repo = mkOption {
        type = types.str;
        description = "Github repo in form of 'organization/repository'";
      };

      subfolderPrefix = mkOption {
        type = with types; nullOr str;
        default = null;
        description = "Optional subfolders prefix";
      };

      subfolders = mkOption {
        type = with types; nullOr (listOf str);
        default = null;
        description = "Optional list of subfolders";
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

  znapSourceFor = source:
    with builtins; with customLib;
    let
      prefix = strings.optionalString (!isNullOrEmpty source.subfolderPrefix) "${source.subfolderPrefix}/";
      subfolders =
        strings.optionalString (!isNullOrEmpty source.subfolders)
          (if (length source.subfolders == 1)
          then head source.subfolders
          else ''{${concatStringsSep "," source.subfolders}}'');
    in
    ''znap source ${source.repo} ${prefix}${subfolders}'';
in
{
  ###### interface
  options = {
    custom.programs.zsh.snap = {
      enable = mkEnableOption "zsh-snap";

      reposDir = mkOption {
        type = with types; nullOr str;
        default = null;
        description = "Custom repos dir";
      };

      sources = mkOption {
        type = with types; nullOr (listOf sourceModule);
        description = "Optional list of sources to install and manage by zsh-snap";
      };

      fpaths = mkOption {
        type = with types; nullOr (listOf fpathModule);
        description = "Optional list of fpath functions";
      };
    };
  };


  ###### implementation
  config = mkIf cfg.enable {
    programs.zsh.initExtra = with builtins; with customLib;
      ''
        ${strings.optionalString (!isNullOrEmpty cfg.reposDir) "zstyle ':znap:*' repos-dir ${cfg.reposDir}"}
        source ${zsh-snap}/znap.zsh

        ${strings.optionalString (!isNullOrEmpty cfg.sources) (concatStringsSep "\n" (map znapSourceFor cfg.sources))}
      '';
  };
}
