{ self, config, lib, ... }:
let
  cfg = config.custom.dotfiles;

  root = if (lib.hasSuffix "/" cfg.root) then cfg.root else "${cfg.root}/";
  toRelativePath = path: lib.strings.removePrefix root (lib.strings.unsafeDiscardStringContext path);
  allDotiles = lib.filesystem.listFilesRecursive cfg.root;
  mappedDotfiles = builtins.listToAttrs (builtins.map (file: { name = toRelativePath file; value = { source = file; }; }) allDotiles);
in
{
  ###### interface
  options = with lib; {
    custom.dotfiles = {
      enable = mkEnableOption "dotfiles";

      root = mkOption {
        type = types.path;
        default = "${self}/dotfiles";
      };
    };
  };


  ###### implementation
  config = lib.mkIf cfg.enable {
    home.file = mappedDotfiles;
  };
}
