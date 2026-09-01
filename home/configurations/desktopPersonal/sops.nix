{
  config,
  ...
}:
{
  sops = {
    age = {
      generateKey = true;
      sshKeyPaths = [
        "${config.home.homeDirectory}/.ssh/id_main"
      ];
    };

    secrets = {
      "mcp/searxng/url" = { };
    };
  };
}
