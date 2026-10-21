{
  lib,
  ...
}:
{
  programs.ghostty.settings = {
    # Linux Ghostty binds this by default; macOS uses Cmd+T instead.
    keybind = [ "ctrl+shift+t=new_tab" ];
    macos-option-as-alt = lib.mkDefault "left";
  };
}
