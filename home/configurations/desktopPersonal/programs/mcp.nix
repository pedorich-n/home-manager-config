{
  config,
  ...
}:
{
  programs.mcp = {
    servers = {
      searxng = {
        inherit (config.custom.secrets.plaintext.mcp.searxng) url;
      };

      trawl = {
        inherit (config.custom.secrets.plaintext.mcp.trawl) url;
      };
    };
  };
}
