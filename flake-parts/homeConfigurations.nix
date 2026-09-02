{

  flake.builders.homeConfigurations = {
    desktopPersonal = {
      system = "x86_64-linux";
      withSharedModules = true;
      presets = [
        "common"
        "standalone"
        "gui"
        "linux"
        "secrets"
      ];
    };

    linuxWork = {
      system = "x86_64-linux";
      withSharedModules = true;
      presets = [
        "common"
        "standalone"
        "gui"
        "linux"
        "secrets"
      ];
    };

    macWork = {
      system = "aarch64-darwin";
      withSharedModules = true;
      presets = [
        "common"
        "standalone"
        "gui"
        "mac"
      ];
    };

    wslPersonal = {
      system = "x86_64-linux";
      withSharedModules = true;
      presets = [
        "common"
        "standalone"
        "linux"
      ];
    };
  };
}
