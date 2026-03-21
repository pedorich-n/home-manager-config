{
  config,
  lib,
  pkgs,
  ...
}:
{
  home = lib.mkIf config.programs.plasma.enable {
    packages = [
      pkgs.nerd-fonts.fira-code # IDE & terminal font
      pkgs.rubik # UI font
    ];
  };

  programs.plasma.fonts = {
    general = {
      family = "Rubik";
      pointSize = 11;
    };

    fixedWidth = {
      family = "FiraCode Nerd Font Mono";
      pointSize = 11;
    };

    small = {
      family = "Rubik";
      pointSize = 8;
    };

    menu = {
      family = "Rubik";
      pointSize = 11;
    };

    toolbar = {
      family = "Rubik";
      pointSize = 9;
    };
  };
}
