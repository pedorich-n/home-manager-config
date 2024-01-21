{ self, lib, config, customLib, ... }:
with lib;
let
  layouts = customLib.listFilesWithExtension ".kdl" "${self}/dotfiles/zellij/layouts";
  toXdgFilePath = with strings; path: unsafeDiscardStringContext (removePrefix "${self}/dotfiles/" path);
in
{
  xdg.configFile = attrsets.optionalAttrs config.programs.zellij.enable
    (customLib.mapListToAttrs (path: nameValuePair (toXdgFilePath path) { text = builtins.readFile path; }) layouts);

  programs.zellij = {
    enable = true;
    settings = {
      copy_command = "xclip -selection clipboard";
    };
  };
}
