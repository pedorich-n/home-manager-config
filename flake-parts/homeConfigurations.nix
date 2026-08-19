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
  };
}
