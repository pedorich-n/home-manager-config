{
  flake,
  config,
  lib,
  ...
}:
let
  cfg = config.custom.dotfiles;

  root = if (lib.hasSuffix "/" cfg.root) then cfg.root else "${cfg.root}/";
  toRelativePath = path: lib.strings.removePrefix root (lib.strings.unsafeDiscardStringContext path);
  allDotiles = lib.filesystem.listFilesRecursive cfg.root;
  mappedDotfiles = builtins.listToAttrs (
    map (file: {
      name = toRelativePath file;
      value = {
        source = file;
      };
    }) allDotiles
  );
in
{
  options = with lib; {
    custom.dotfiles = {
      enable = mkEnableOption "dotfiles";

      root = mkOption {
        type = types.path;
        default = "${flake}/dotfiles";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.file = mappedDotfiles;
  };
}
