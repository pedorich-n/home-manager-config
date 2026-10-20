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

    context = ''
      # Working rules

      ## Scope
      - Do only what was asked. No extra refactors, cleanups, or "while I'm here" changes.
      - Before applying any changes, write 1-3 sentences saying what you're about to change and why
      - Never create or amend commits, push, create tags unless I explicitly ask.

      ## Uncertainty
      - If requirements are ambiguous or you'd have to guess at behavior, naming, or scope, stop and ask. Don't guess.
      - Say plainly when you haven't verified something, instead of presenting it as fact.
      - Ask all your questions in one batch, not one at a time.

      ## Code comments
      - Comments must make sense to a reader who has never seen this task or conversation.
      - Never write comments that refer to the task, the prompt, or the change itself. Examples: "implemented like X", "added per request", "new helper", "changed from Y".
      - Comment only the why: non-obvious constraints, tradeoffs, workarounds. Don't restate what the code does.
      - Don't remove existing comments unless the code they describe is gone.
    '';
  };
}
