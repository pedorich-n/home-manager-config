{
  lib,
  ...
}:
{
  custom = {
    deploymentType.isStandalone = true;

    aliases = {
      enable = lib.mkDefault true;
      hm.enable = lib.mkDefault true;
      hms.enable = lib.mkDefault true;
    };

    programs = {
      # HomeManager Diff tool, built using NVM (Nix Version Diff)
      hmd = {
        enable = lib.mkDefault true;
        runOnSwitch = lib.mkDefault false;
      };
    };
  };
}
