{
  config,
  ...
}:
{
  sops = {
    gnupg = {
      home = "${config.home.homeDirectory}/.gnupg";
    };

    secrets = {
      "mcp/searxng/cf_client_id" = { };
      "mcp/searxng/cf_client_secret" = { };
    };
  };
}
