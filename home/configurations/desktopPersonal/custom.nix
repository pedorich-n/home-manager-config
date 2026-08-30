{
  pkgs,
  ...
}:
{
  custom = {
    selinux.enable = true;
    dotfiles.enable = true;
    aliases.hms.configName = "desktopPersonal";
    programs = {
      gpg.enable = true;
      python = {
        enable = true;
        uv.enable = true;
      };
      plasma.themes.enable = true;
    };

    runtimes = {
      enable = true;
      java = [
        pkgs.jdk21
      ];
    };
  };
}
