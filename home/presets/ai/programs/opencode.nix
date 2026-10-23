{
  config,
  lib,
  pkgs,
  ...
}:
let
  isLinux = pkgs.stdenv.hostPlatform.isLinux;

  osTmpEnv =
    if pkgs.stdenv.hostPlatform.isDarwin then
      "TMPDIR"
    else if isLinux then
      "XDG_RUNTIME_DIR"
    else
      throw "Unexpected hostPlatform!";

in
{
  systemd.user.tmpfiles.rules = lib.mkIf isLinux [
    "d %t/opencode 0700 - - -"
  ];

  launchd.agents.opencode-scratch-dir = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
    domain = "user";
    config = {
      ProgramArguments = [
        "/bin/sh"
        "-c"
        "/bin/mkdir -p \"$(/usr/bin/getconf DARWIN_USER_TEMP_DIR)opencode\""
      ];
      RunAtLoad = true;
    };
  };

  # This writes the config to `opencode.json` file, leaving the `opencode.jsonc` file mutable.
  # OpenCode loads both of these files and merges configs, so it's possible to have both a mutable and immutable configs
  programs.opencode = {
    enable = lib.mkDefault true;
    enableMcpIntegration = lib.mkDefault true;

    settings = {
      permission = {
        external_directory = {
          "{env:${osTmpEnv}}/opencode/**" = "allow";
        };
      };
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
        Directory `${"$"}${osTmpEnv}/opencode/` is the scratch files root for OpenCode.
        Create a per-session directory using `mktemp -d` under this root. Use this directory to store disposable non-secret work.
        Assume this directory is deleted when the session ends; save persistent outputs in the project or another explicitly requested location.
        Don't delete the session or root directories yourself.
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
