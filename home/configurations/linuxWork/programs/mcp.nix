{
  config,
  ...
}:
{
  programs.mcp = {
    servers = {
      searxng = {
        inherit (config.custom.secrets.plaintext.mcp.searxng) url;
        headers = {
          # `file:` Directive might not be supported by all agents.
          "CF-Access-Client-Id" = "{file:${config.sops.secrets."mcp/searxng/cf_client_id".path}}";
          "CF-Access-Client-Secret" = "{file:${config.sops.secrets."mcp/searxng/cf_client_secret".path}}";
        };
      };

      confluence = {
        url = "https://mcp.atlassian.com/v1/mcp";
      };
    };
  };
}
