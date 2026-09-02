{
  inputs,
  lib,
  sopsLib,
  ...
}:
{
  imports = [ inputs.sops-nix.homeManagerModules.default ];

  config = {
    sops = {
      defaultSopsFile = lib.mkDefault "${sopsLib.secretsRoot}/secrets.yaml";
    };
  };
}
