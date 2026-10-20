{
  lib,
  pkgs,
  ...
}:
{
  fonts.fontconfig.enable = lib.mkDefault pkgs.stdenv.hostPlatform.isLinux;
}
