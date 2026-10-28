{
  lib,
  ...
}:
{
  programs.ghostty = {
    # See https://ghostty.org/docs/config/reference
    settings = {
      auto-update = lib.mkDefault "off";
      font-family = lib.mkDefault "FiraCode Nerd Font Mono";
      theme = lib.mkDefault "Adwaita Dark";
      confirm-close-surface = lib.mkDefault false;
      cursor-style = lib.mkDefault "block";
      # Shell integration switches the cursor to a bar at the prompt, overriding `cursor-style`.
      shell-integration-features = lib.concatStringsSep "," [
        "no-cursor"
        "sudo"
        "ssh-env"
      ];
      keybind = [
        "shift+alt+arrow_left=move_tab:-1"
        "shift+alt+arrow_right=move_tab:1"
        "shift+alt+bracket_left=previous_tab"
        "shift+alt+bracket_right=next_tab"
      ];
    };
  };
}
