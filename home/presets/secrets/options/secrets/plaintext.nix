{
  inputs,
  config,
  lib,
  ...
}:
let
  file = "${inputs.home-manager-config-secrets}/plaintext/rendered/${config.custom.configName}/variables.nix";
in
{
  options = {
    custom.secrets.plaintext = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      readOnly = true;
    };
  };

  config = {
    custom.secrets.plaintext = if builtins.pathExists file then import file else { };
  };
}
