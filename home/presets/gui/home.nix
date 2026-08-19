{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    nerd-fonts.fira-code # IDE & terminal font
  ];
}
