{
  config,
  ...
}:
{
  programs.mcp = {
    enable = true;

    servers = {
      searxng = {
        inherit (config.custom.secrets.plaintext.mcp.searxng) url;
        headers = {
          "CF-Access-Client-Id" = "{file:${config.sops.secrets."mcp/searxng/cf_client_id".path}}";
          "CF-Access-Client-Secret" = "{file:${config.sops.secrets."mcp/searxng/cf_client_secret".path}}";
        };
      };
    };
  };
}
