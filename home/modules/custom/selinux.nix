{
  config,
  lib,
  pkgs,
  ...
}:
{

  options = {
    custom.selinux = {
      enable = lib.mkEnableOption "Custom SELinux configuration";
    };
  };

  config = {
    home.packages = [
      (pkgs.coreutils-full.override { selinuxSupport = config.custom.selinux.enable; })
    ];
  };
}
