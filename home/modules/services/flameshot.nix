{ lib, ... }: {
  services.flameshot = {
    settings = lib.mkDefault {
      # https://github.com/flameshot-org/flameshot/blob/master/flameshot.example.ini
      General = {
        allowMultipleGuiInstances = true;
        buttons = ''@Variant(\0\0\0\x7f\0\0\0\vQList<int>\0\0\0\0\x11\0\0\0\0\0\0\0\x1\0\0\0\x2\0\0\0\x3\0\0\0\x4\0\0\0\x5\0\0\0\x6\0\0\0\x12\0\0\0\xf\0\0\0\x13\0\0\0\b\0\0\0\t\0\0\0\x10\0\0\0\n\0\0\0\v\0\0\0\x17\0\0\0\f)'';
        saveAsFileExtension = ".png";
        useJpgForClipboard = true;
        contrastOpacity = 188;
        drawColor = "#ffff00";
        filenamePattern = "%F_%T";
        disabledTrayIcon = false;
        showDesktopNotification = false;
        showStartupLaunchMessage = false;
        startupLaunch = true;
      };
    };
  };
}
