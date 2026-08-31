{
  config,
  inputs,
  ...
}:
let
  configName = config.custom.configName;
in
{
  _module.args.sopsLib = rec {
    secretsRoot = "${inputs.home-manager-config-secrets}/sops/encrypted/${configName}";
    mkSopsFile = relPath: "${secretsRoot}/${relPath}";
  };
}
