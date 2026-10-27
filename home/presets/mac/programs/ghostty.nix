{
  lib,
  ...
}:
{
  programs.ghostty = {
    enable = true;
    package = null; # Installed via HomeBrew
    settings = {
      font-size = 14;
      keybind = [
        "ctrl+shift+t=new_tab"
        "ctrl+shift+f=start_search"
      ];
      macos-option-as-alt = lib.mkDefault "left";
    };
  };
}
