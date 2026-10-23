{
  config,
  lib,
  pkgs,
  ...
}:
{

  programs.opencode = {
    enable = lib.mkDefault true;
    # This will write the config to `opencode/opencode.json` file, leaving the `opencode.jsonc` file mutable.
    # OpenCode loads both of these files and merges configs.
    enableMcpIntegration = lib.mkDefault true;

    settings = {
      permissions = [
        {
          action = "external_directory";
          resource = "*";
          effect = "ask";
        }
        {
          action = "external_directory";
          # TMPDIR ends in a slash on Darwin; XDG_RUNTIME_DIR does not on Linux.
          resource = if pkgs.stdenv.hostPlatform.isDarwin then "{env:TMPDIR}opencode/*" else "{env:XDG_RUNTIME_DIR}/opencode/*";
          effect = "allow";
        }
        {
          action = "read";
          resource = "/nix/store/*";
          effect = "allow";
        }
      ];
    };

    context = lib.mkMerge [
      (lib.mkBefore ''
        # Working rules

        Project-level AGENTS.md rules override these where they conflict.

        ## Scope
        Do only what was asked. No extra refactors, cleanups, or "while I'm here" changes.
        Before the first edit of a task (and when the plan changes), write 1-3 sentences saying what you're about to change and why
        Never create or amend commits, push, create tags unless I explicitly ask.

        ## Uncertainty
        Ask when the choice affects behavior or is hard to reverse.
        Say plainly when you haven't verified something, instead of presenting it as fact.
        Ask all your questions in one batch, not one at a time.

        ## Code comments
        Comments must make sense to a reader who has never seen this task or conversation.
        Never write comments that refer to the task, the prompt, or the change itself. Examples: "implemented like X", "added per request", "new helper", "changed from Y".
        Comment only the why: non-obvious constraints, tradeoffs, workarounds. Don't restate what the code does.
        Don't remove existing comments unless the code they describe is gone.

        ## Temporary scratch directory
        Work in a per-session subdirectory of the scratch root, created with `mktemp -d`; never write into
        the root itself and don't delete it. Contents are disposable, non-secret, and gone when the session
        ends — put anything persistent in the project or an explicitly requested location.
      '')
      (lib.mkIf (config.programs.mcp.servers.fff.enabled or false) ''
        ## Search
        For any file search or grep in the current git-indexed directory, prefer fff tools (`fff-mcp`, `ffgrep`, `fffind`).
        Include the known directory or module in the first search. Use definitions_only for declarations.
        Read more source only when the returned lines need context.
        If `fff` tools are unavailable, error out, or return nothing, fall back to `rg`/`fd`
      '')
    ];
  };
}
