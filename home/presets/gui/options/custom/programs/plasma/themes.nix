{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.custom.programs.plasma.themes;

  filterBySubdir = subdir: lib.filter (pkg: builtins.pathExists "${pkg}/${subdir}") cfg.packages;

  mkSource =
    {
      name,
      prefix,
      paths,
    }:
    pkgs.symlinkJoin {
      name = "kde-themes-${name}";
      stripPrefix = "/${prefix}";
      inherit paths;
    };

  kvantumPackages = filterBySubdir "share/Kvantum";
in
{
  options = {
    custom.programs.plasma.themes = {
      enable = lib.mkEnableOption "Whether to enable custom KDE themes features.";

      packages = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = [ ];
        description = ''
          List of KDE themes to be installed.
          Expected outputs:
            - `$out/share`. Should include plasma themes, aurorae themes, icons, and other KDE-related files.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home = {
      packages = lib.mkIf (cfg.packages != [ ]) cfg.packages;

      file = lib.mkMerge [
        (lib.mkIf (kvantumPackages != [ ]) {
          ".config/Kvantum" = {
            recursive = true;
            source = mkSource {
              name = "kvantum";
              prefix = "share/Kvantum";
              paths = kvantumPackages;
            };
          };
        })
      ];
    };
  };
}
