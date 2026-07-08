{

  flake.builders.homeConfigurations = {
    desktopPersonal = {
      system = "x86_64-linux";
      withSharedModules = true;
      presets = [
        "common"
        "standalone"
      ];
    };

    linuxWork = {
      system = "x86_64-linux";
      withSharedModules = true;
      presets = [
        "common"
        "standalone"
      ];
    };

    macWork = {
      system = "aarch64-darwin";
      withSharedModules = true;
      presets = [
        "common"
        "standalone"
      ];
    };

    wslPersonal = {
      system = "x86_64-linux";
      withSharedModules = true;
      presets = [
        "common"
        "standalone"
      ];
    };
  };
}
