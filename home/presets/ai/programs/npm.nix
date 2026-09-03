{
  lib,
  ...
}:
{
  programs.npm = {
    enable = lib.mkDefault true;
  };
}
