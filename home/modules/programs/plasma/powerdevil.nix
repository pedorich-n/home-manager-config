{
  programs.plasma.powerdevil = {
    batteryLevels = {
      lowLevel = 30;
      criticalLevel = 5;
    };

    AC = {
      powerButtonAction = "sleep";

      autoSuspend = {
        action = "sleep";
        idleTimeout = 3600;
      };

      dimDisplay = {
        enable = true;
        idleTimeout = 600;
      };

      turnOffDisplay = {
        idleTimeout = 1800;
        idleTimeoutWhenLocked = 20;
      };
    };

    battery = {
      powerButtonAction = "showLogoutScreen";
      displayBrightness = 90;

      dimDisplay = {
        enable = true;
        idleTimeout = 120;
      };

      turnOffDisplay = {
        idleTimeout = 300;
        idleTimeoutWhenLocked = 20;
      };
    };

    lowBattery = {
      powerButtonAction = "showLogoutScreen";
      displayBrightness = 70;
      powerProfile = "powerSaving";

      dimDisplay = {
        enable = true;
        idleTimeout = 60;
      };

      turnOffDisplay = {
        idleTimeout = 120;
        idleTimeoutWhenLocked = 20;
      };
    };
  };

}
