{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.custom.kde;

  packagesToLink = lib.filter (pkg: pkg ? link) cfg.themes;

  filterBySubdir = subdir: lib.filter (pkg: builtins.pathExists "${pkg.link}/${subdir}") packagesToLink;

  mkSource =
    {
      name,
      prefix ? name,
      paths,
    }:
    pkgs.symlinkJoin {
      name = "kde-themes-${name}";
      paths = map (pkg: pkg.link) paths;
      stripPrefix = "/${prefix}";
    };

  kvantumPackages = filterBySubdir "kvantum";
in
{
  options = {
    custom.kde = {
      enable = lib.mkEnableOption "Whether to enable custom KDE features.";

      themes = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = [ ];
        description = "List of KDE themes to be installed. Expected outputs: `$out`, `$link`.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home = {
      packages = lib.mkIf (cfg.themes != [ ]) cfg.themes;

      file = lib.mkMerge [
        (lib.mkIf (kvantumPackages != [ ]) {
          ".config/Kvantum" = {
            recursive = true;
            source = mkSource {
              name = "kvantum";
              paths = kvantumPackages;
            };
          };
        })
      ];
    };
  };
}
