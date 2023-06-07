{ self, lib, config, customLib, ... }:
with lib;
let
  cfg = config.custom.programs.zellij;

  layouts = customLib.listFilesWithExtension ".kdl" "${self}/dotfiles/zellij/layouts";
  toXdgFilePath = with strings; path: unsafeDiscardStringContext (removePrefix "${self}/dotfiles/" path);
in
{
  ###### interface
  options = {
    custom.programs.zellij = {
      enable = mkEnableOption "zellij";
    };
  };


  ###### implementation
  config = mkIf cfg.enable {
    xdg.configFile = customLib.mapListToAttrs (path: nameValuePair (toXdgFilePath path) { text = builtins.readFile path; }) layouts;

    programs.zellij = {
      enable = true;
    };
  };
}
