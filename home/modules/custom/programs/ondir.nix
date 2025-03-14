{ config, lib, pkgs, ... }:
let
  cfg = config.custom.programs.ondir;

  entrySubmodule = lib.types.submodule {
    options = {
      type = lib.mkOption {
        type = lib.types.enum [ "enter" "leave" ];
      };

      script = lib.mkOption {
        type = lib.types.submodule {
          options = {
            text = lib.mkOption {
              default = null;
              type = lib.types.nullOr lib.types.lines;
            };

            source = lib.mkOption {
              type = lib.types.path;
            };
          };
        };
      };
    };
  };

  generatedSettings =
    let
      generateEntry = path: entry: ''
        ${entry.type} ${path}
        \t${entry.script.text or entry.script.source}
      '';
    in
    lib.mapAttrsToList (path: entries: "") cfg.config;
in
{
  options = {
    custom.programs.ondir = {
      enable = lib.mkEnableOption "Enable ondir";

      package = lib.mkPackageOption pkgs "ondir";

      config = lib.mkOption {
        type = lib.types.attrsOf (lib.types.listOf entrySubmodule);
        default = { };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home = {
      packages = [ cfg.package ];

      file.".ondirrc".source = "";
    };

  };
}
