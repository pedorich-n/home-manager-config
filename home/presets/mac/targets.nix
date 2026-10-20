{
  lib,
  ...
}:
{
  targets.darwin = {
    copyApps.enable = lib.mkDefault true;

    defaults = {
      NSGlobalDomain = {
        AppleShowAllExtensions = lib.mkDefault true;
        # Key repeat instead of the accent popup when holding a key.
        ApplePressAndHoldEnabled = lib.mkDefault false;
        KeyRepeat = lib.mkDefault 2;
        InitialKeyRepeat = lib.mkDefault 25;
      };

      "com.apple.dock" = {
        autohide = lib.mkDefault true;
        autohide-delay = lib.mkDefault 0.1;
        orientation = lib.mkDefault "left";
        tilesize = lib.mkDefault 128;
      };

      "com.apple.finder" = {
        AppleShowAllFiles = lib.mkDefault true;
      };

      # Tap to click; the trackpad driver and the Bluetooth trackpad driver keep separate copies.
      "com.apple.AppleMultitouchTrackpad".Clicking = lib.mkDefault true;

      # Don't reopen windows when logging back in.
      "com.apple.loginwindow".TALLogoutSavesState = lib.mkDefault false;

      "com.apple.HIToolbox" = {
        # Pressing 🌐/Control alone does nothing; by default it switches the input source.
        AppleFnUsageType = lib.mkDefault 0;
      };
    };
  };
}
