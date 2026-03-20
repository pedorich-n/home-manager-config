{
  # config,
  # pkgs,
  lib,
  ...
}:
{
  options = {
    custom.kde.themes = {
      plasma = lib.mkOption {
        type = lib.attrsOf lib.types.path;
        description = "Plasma themes to be installed.";
      };

      lookAndFeel = lib.mkOption {
        type = lib.attrsOf lib.types.path;
        description = "Look and feel themes to be installed.";
      };

      colorSchemes = lib.mkOption {
        type = lib.attrsOf lib.types.path;
        description = "Color schemes to be installed.";
      };

      aurorae = lib.mkOption {
        type = lib.attrsOf lib.types.path;
        description = "Aurorae themes to be installed.";
      };

      kvantum = lib.mkOption {
        type = lib.attrsOf lib.types.path;
        description = "Kvantum themes to be installed.";
      };

      gtk = lib.mkOption {
        type = lib.attrsOf lib.types.path;
        description = "GTK themes to be installed.";
      };
    };
  };
}
