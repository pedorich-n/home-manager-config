{ pkgs, lib, config, customLib, zsh-snap, ... }:
with lib;
let
  cfg = config.custom.programs.zsh.snap;

  sourceModule = types.submodule ({
    options = {
      repo = mkOption {
        type = types.str;
        description = "Github repo in form of organization/repository";
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
  });

  znapSourceFor = source:
    with builtins; with customLib;
    let
      prefix = strings.optionalString (!isStringNullOrEmpty (source.subfolderPrefix)) "${source.subfolderPrefix}/";
      subfolders =
        strings.optionalString (!isListNullOrEmpty (source.subfolders))
          (if (length (source.subfolders) == 1)
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
        type = types.listOf sourceModule;
        description = "Optional list of sources to install and manage by zsh-snap";
      };

    };
  };


  ###### implementation
  config = mkIf cfg.enable {
    programs.zsh.initExtra = with builtins; with customLib;
      ''
        ${strings.optionalString (!isStringNullOrEmpty (cfg.reposDir)) "zstyle ':znap:*' repos-dir ${cfg.reposDir}"}
        source ${zsh-snap}/znap.zsh

        ${(concatStringsSep "\n" (map (znapSourceFor) cfg.sources))}
      '';
  };
}
