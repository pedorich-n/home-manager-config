{
  lib,
  pkgs,
  ...
}:
let
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
  isLinux = pkgs.stdenv.hostPlatform.isLinux;

  scratchDir =
    if isDarwin then
      # Apparently not all processes inherit `TMPDIR`, so `getconf` is more reliable
      "$(getconf DARWIN_USER_TEMP_DIR)opencode"
    else if isLinux then
      "$XDG_RUNTIME_DIR/opencode"
    else
      throw "Unexpected hostPlatform!";

  permissionsScratchDir =
    if isDarwin then
      "{env:TMPDIR}opencode/*" # TMPDIR ends in a slash on Darwin
    else if isLinux then
      "{env:XDG_RUNTIME_DIR}/opencode/*" # XDG_RUNTIME_DIR does not on Linux
    else
      throw "Unexpected hostPlatform!";
in
{

  programs.opencode = {
    enable = lib.mkDefault true;
    # This will write the config to `opencode/opencode.json` file, leaving the `opencode.jsonc` file mutable.
    # OpenCode loads both of these files and merges configs.
    enableMcpIntegration = lib.mkDefault true;

    settings = {
      permissions = lib.mkBefore [
        {
          action = "external_directory";
          resource = "*";
          effect = "ask";
        }
        {
          action = "external_directory";
          resource = "/nix/store/*";
          effect = "allow";
        }
        {
          action = "read";
          resource = "/nix/store/*";
          effect = "allow";
        }
        {
          action = "external_directory";
          resource = permissionsScratchDir;
          effect = "allow";
        }
        {
          action = "edit";
          resource = permissionsScratchDir;
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
        Work in a per-session subdirectory of the scratch root, created with `mktemp -d "${scratchDir}/session.XXXXXX"`;
        never write into the root itself and don't delete it. Contents are disposable, non-secret, and gone when the session
        ends — put anything persistent in the project or an explicitly requested location.

        ## Destructive commands
        Never run `rm -rf`, `rmdir`, `mv`, `chmod`, `chown`, `dd`, `truncate`, `shred` or `find -delete` against a path outside the project directory.
        If a task appears to need it, name the exact path and ask first.
      '')
    ];
  };
}
