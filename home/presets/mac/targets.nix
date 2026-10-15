{
  lib,
  ...
}:
{
  targets.darwin = {
    copyApps.enable = lib.mkDefault true;
  };
}
