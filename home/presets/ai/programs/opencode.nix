{
  pkgs,
  lib,
  opencodeLib,
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
      "/tmp/opencode"
    else
      throw "Unexpected hostPlatform!";

  permissionsScratchDir =
    if isDarwin then
      "{env:TMPDIR}opencode/*" # TMPDIR ends in a slash on Darwin
    else if isLinux then
      "/tmp/opencode/*"
    else
      throw "Unexpected hostPlatform!";
in
{

  xdg.configFile = {
    "opencode/oh-my-opencode-slim/orchestrator_append.md".text = ''
      ## Delegation handover

      When you delegate, hand over what you have already established: paths, line
      references, and the conclusions you reached. A delegate that re-derives them
      pays for the same work twice.
    '';
  };

  programs.opencode = {
    enable = lib.mkDefault true;
    # This will write the config to `opencode/opencode.json` file, leaving the `opencode.jsonc` file mutable.
    # OpenCode loads both of these files and merges configs.
    enableMcpIntegration = lib.mkDefault true;

    settings = {
      permissions = lib.mkBefore (
        lib.flatten [
          (lib.singleton {
            action = "external_directory";
            resource = "*";
            effect = "ask";
          })
          (opencodeLib.mkExternalDirectoryPermissions {
            path = "/nix/store/*";
          })
          (opencodeLib.mkExternalDirectoryPermissions {
            path = permissionsScratchDir;
            actionEffect = "edit";
          })
          (opencodeLib.mkShellPermission {
            command = "rm -rf *";
          })
          (opencodeLib.mkShellPermission {
            command = "dd *";
            effect = "deny";
          })
          (opencodeLib.mkShellPermission {
            command = "truncate *";
            effect = "deny";
          })
          (opencodeLib.mkShellPermission {
            command = "shred *";
            effect = "deny";
          })
          (opencodeLib.mkShellPermission {
            command = "find * -delete";
            effect = "deny";
          })
        ]
      );

    };

    context = lib.mkMerge [
      (lib.mkBefore ''
        # Working rules

        Project-level AGENTS.md rules override these where they conflict.
        Where these rules conflict with the existing code or its tests, the code and tests win:
        follow them and name the contradiction instead of rewriting them to match the rules.

        ## Scope
        Do only what was asked. No extra refactors, cleanups, or "while I'm here" changes.
        Before the first edit of a task (and when the plan changes), write 1-3 sentences saying what you're about to change and why
        Never create or amend commits, push, create tags unless I explicitly ask.

        ## Reading
        Read the region you need — the enclosing function plus its callers — rather than whole files.
        Widen only when the narrow read doesn't answer the question.

        ## Uncertainty
        Ask when the choice affects behavior or is hard to reverse.
        Say plainly when you haven't verified something, instead of presenting it as fact.
        Ask all your questions in one batch, not one at a time.

        ## Code comments
        Comments explain why for a reader with no context: constraints, tradeoffs, workarounds —
        never the task, prompt, or diff that produced the code. Keep existing comments unless their code is gone.

        ## Temporary scratch directory
        Work in a per-session subdirectory of the scratch root, created with `mktemp -d "${scratchDir}/session.XXXXXX"`;
        never write into the root itself and don't delete it. Contents are disposable, non-secret, and gone when the session
        ends — put anything persistent in the project or an explicitly requested location.

        ## Filesystem scope
        Work inside the project directory. Before touching any path outside it, name the exact path and ask.
        If a command is blocked or a path is refused, stop and ask — do not look for another way to reach it.
      '')
    ];
  };
}
