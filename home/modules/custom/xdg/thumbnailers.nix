{
  config,
  lib,
  ...
}:
let
  cfg = config.custom.xdg.thumbnailers;
in
{
  options = {
    custom.xdg.thumbnailers = {
      enable = lib.mkEnableOption "Link custom thumbnailers";
    };
  };

  config = lib.mkIf cfg.enable {
    xdg.dataFile."thumbnailers" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.nix-profile/share/thumbnailers";
    };
  };
}
