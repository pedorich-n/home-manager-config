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
      };
    };
  };
}
