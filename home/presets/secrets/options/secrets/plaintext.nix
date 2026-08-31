{
  inputs,
  config,
  lib,
  ...
}:
{
  options = {
    custom.secrets.plaintext = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      readOnly = true;
    };
  };

  config = {
    custom.secrets.plaintext = import "${inputs.home-manager-config-secrets}/plaintext/rendered/${config.custom.configName}/variables.nix";
  };
}
