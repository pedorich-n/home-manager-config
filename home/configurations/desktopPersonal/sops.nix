{
  config,
  pkgs,
  ...
}:
let
  writeYAML = (pkgs.formats.yaml_1_2 { }).generate;
in
{
  sops = {
    age = {
      keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
    };

    secrets = {
      "github/opencode" = { };
    };

    templates = {
      "github/opencode-hosts.yml".file = writeYAML "github-opencode-hosts-template.yml" {
        "github.com" = {
          oauth_token = config.sops.placeholder."github/opencode";
          user = "pedorich-n";
        };
      };
    };
  };
}
