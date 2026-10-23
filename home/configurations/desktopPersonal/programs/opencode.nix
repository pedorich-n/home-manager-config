{
  pkgs,
  ...
}:
{
  programs.opencode = {
    # Opencode's system prompt sets the scratch directory to /tmp/opencode on Linux (https://github.com/anomalyco/opencode/blob/2a3e7c0f349ba0e9454fa0/packages/core/src/instructions/builtins.ts#L43)
    # And it's hard to convince it to use anything else, since the system prompt has higher priority
    # So instead by setting TMPDIR=XDG_RUNTIME_DIR, the opencode will inject the correct folder into the system prompt
    # See:
    #  - https://github.com/anomalyco/opencode/issues/49073
    #  - https://github.com/anomalyco/opencode/issues/55006
    package = pkgs.opencode-xdg-tmpdir;
    settings = {
      permissions = [
        {
          action = "external_directory";
          resource = "$HOME/Projects/*";
          effect = "allow";
        }
        {
          action = "edit";
          resource = "$HOME/Projects/*";
          effect = "allow";
        }
      ];
    };
  };
}
