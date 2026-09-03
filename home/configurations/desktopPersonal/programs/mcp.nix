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
    };
  };
}
