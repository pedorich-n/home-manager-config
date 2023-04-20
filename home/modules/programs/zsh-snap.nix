{ lib, config, customLib, pkgs, ... }:
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
      prefix = strings.optionalString (nonEmpty source.subfolderPrefix) "${source.subfolderPrefix}/";
      subfolders =
        strings.optionalString (nonEmpty source.subfolders)
          (if (length source.subfolders == 1)
          then head source.subfolders
          else ''{${concatStringsSep "," source.subfolders}}'');
    in
    ''znap source ${source.repo} ${prefix}${subfolders}'';

  znapFpathFor = fpath: "znap fpath ${fpath.name} '${fpath.command}'";
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
        default = null;
        description = "Optional list of sources to install and manage by zsh-snap";
      };

      fpaths = mkOption {
        type = with types; nullOr (listOf fpathModule);
        default = null;
        description = "Optional list of fpath functions";
      };
    };
  };


  ###### implementation
  config = mkIf cfg.enable {
    home.packages = [ pkgs.zsh-snap ];

    programs.zsh.initExtra = with builtins; with customLib;
      ''
        ${strings.optionalString (nonEmpty cfg.reposDir) "zstyle ':znap:*' repos-dir ${cfg.reposDir}"}
        source ${pkgs.zsh-snap}/znap.zsh

        ${strings.optionalString (nonEmpty cfg.sources) (concatStringsSep "\n" (map znapSourceFor cfg.sources))}

        ${strings.optionalString (nonEmpty cfg.fpaths) (concatStringsSep "\n" (map znapFpathFor cfg.fpaths))}
      '';
  };
}
