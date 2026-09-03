{
  lib,
  ...
}:
{
  # This writes the config to `opencode.json` file, leaving the `opencode.jsonc` file mutable.
  # OpenCode loads both of these files and merges configs, so it's possible to have both a mutable and immutable configs
  programs.opencode = {
    enable = lib.mkDefault true;
    enableMcpIntegration = lib.mkDefault true;
  };
}
