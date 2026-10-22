{
  lib,
  ...
}:
{
  programs.ghostty.settings = {
    keybind = [
      "ctrl+shift+t=new_tab"
      "ctrl+shift+f=start_search"
    ];
    macos-option-as-alt = lib.mkDefault "left";
  };
}
