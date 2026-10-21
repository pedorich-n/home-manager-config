{
  pkgs,
  lib,
  ...
}:
{
  home = {
    packages = with pkgs; [
      worktrunk # Git worktree manager for parallel AI agent workflows
    ];

    sessionVariables = {
      # For oh-my-opencode-slim
      OPENCODE_EXPERIMENTAL_BACKGROUND_SUBAGENTS = lib.mkDefault true;
      OPENCODE_ENABLE_EXA = lib.mkDefault 1;
    };
  };

}
