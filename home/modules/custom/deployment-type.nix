{
  config,
  lib,
  ...
}:
let
  cfg = config.custom.deploymentType;
in
{
  options = {
    custom.deploymentType = {
      isStandalone = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether this is a standalone deployment.";
      };

      isNixos = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether this is a NixOS deployment.";
      };
    };
  };

  config = {
    assertions = [
      {
        assertion = !(cfg.isStandalone && cfg.isNixos);
        message = "Only one deployment type can be enabled at a time.";
      }
    ];
  };
}
