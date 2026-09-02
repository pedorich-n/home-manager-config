{
  programs.opencode = {
    enable = true;
    # This will write the config to `opencode/opencode.json` file, leaving the `opencode.jsonc` file mutable.
    # OpenCode loads both of these files and merges configs.
    enableMcpIntegration = true;
  };
}
