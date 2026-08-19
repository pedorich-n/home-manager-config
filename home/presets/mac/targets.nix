{
  lib,
  ...
}:
{
  targets.darwin = {
    copyApps.enable = lib.mkDefault true;
    linkApps.enable = lib.mkDefault true;
  };
}
