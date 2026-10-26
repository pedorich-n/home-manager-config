{
  config,
  lib,
  pkgs,
  ...
}:
let
  selinuxSupport = config.custom.selinux.enable;
in
{
  options.custom.selinux.enable = lib.mkEnableOption "Custom SELinux configuration";

  config.home.packages = [
    (
      if selinuxSupport then
        (pkgs.coreutils-full.override { inherit selinuxSupport; }).overrideAttrs {
          doCheck = false;
        }
      else
        pkgs.coreutils-full
    )
  ];
}
