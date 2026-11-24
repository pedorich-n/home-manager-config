{
  xdg.configFile = {
    "opencode/opencode-notifier.json".text = builtins.toJSON {
      notificationSystem = "ghostty";
      notification = true;
      notificationTitle = "OpenCode · {projectName}";
      sound = false;
      bell = false;
      suppressWhenFocused = true;
      minDuration = 10;
    };
  };

  programs.opencode = {
    settings = {
      permissions = [
        {
          action = "external_directory";
          resource = "$HOME/Work/*";
          effect = "allow";
        }
        {
          action = "edit";
          resource = "$HOME/Work/*";
          effect = "allow";
        }
      ];
    };
  };
}
