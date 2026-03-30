{
  programs.claude-code = {
    settings = {
      env = {
        DISABLE_AUTOUPDATER = "1";
        CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC = "1";
        DISABLE_NON_ESSENTIAL_MODEL_CALLS = "1";
        DISABLE_TELEMETRY = "1";
        DISABLE_INSTALLATION_CHECKS = "1";
        CLAUDE_CODE_DISABLE_AUTO_MEMORY = "0";
        CLAUDE_CODE_USE_BEDROCK = "1";
        CLAUDE_CODE_MAX_OUTPUT_TOKENS = "16384";
        MAX_THINKING_TOKENS = "8192";
      };
    };
  };
}
