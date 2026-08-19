{
  custom = {
    aliases.hms.configName = "wslPersonal";
    programs = {
      gpg.enable = true;
      python = {
        enable = true;
        uv.enable = true;
      };
    };
  };
}
