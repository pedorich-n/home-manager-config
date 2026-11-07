{
  pkgs,
  ...
}:
{
  custom = {
    selinux.enable = true;
    dotfiles.enable = true;
    programs = {
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
