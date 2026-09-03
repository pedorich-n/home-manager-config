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
        "ai"
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
        "ai"
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
        "ai"
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
