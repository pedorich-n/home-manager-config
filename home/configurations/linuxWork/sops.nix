{
  config,
  ...
}:
{
  sops = {
    age = {
      sshKeyPaths = [
        "${config.home.homeDirectory}/.ssh/id_main"
      ];
    };

    secrets = {
      "mcp/searxng/cf_client_id" = { };
      "mcp/searxng/cf_client_secret" = { };
    };
  };
}
