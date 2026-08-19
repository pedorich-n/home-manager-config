{
  lib,
  ...
}:
{
  xdg = {
    enable = lib.mkDefault true;
    userDirs.setSessionVariables = lib.mkDefault true;
  };
}
