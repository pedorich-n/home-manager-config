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
      generateKey = true;
      sshKeyPaths = [
        "${config.home.homeDirectory}/.ssh/id_main"
      ];
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
