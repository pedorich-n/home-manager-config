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
    "opencode/opencode-status-line.json".text = lib.generators.toJSON { } {
      surface = "prompt.footer.status";
      cap = {
        mode = "none";
      };
      readings = [ "cumulative" ];
      usage = {
        warnAt = 60;
        dangerAt = 80;
        segments = [
          "shells"
          "context"
          "cache"
          "meter"
          "cost"
        ];
      };
    };

    "opencode/oh-my-opencode-slim/orchestrator_append.md".text = ''
      ## Delegation handover

      When you delegate, hand over what you have already established: paths, line
      references, and the conclusions you reached. A delegate that re-derives them
      pays for the same work twice.

      If a delegation may create temporary files, include the exact scratch path
      in the brief: `mktemp -d "${scratchDir}/session.XXXXXX"`, never the system
      temp directory itself. The shell's `TMPDIR` may not point at the approved
      scratch root, so a bare `mktemp` can land outside it.
    '';
  };

  programs.opencode = {
    enable = lib.mkDefault true;
    mutableSettings = lib.mkDefault true;
    enableMcpIntegration = lib.mkDefault true;

    settings = {
      permissions = lib.mkMerge [
        (lib.mkBefore (
          lib.flatten [
            (lib.singleton {
              action = "external_directory";
              resource = "*";
              effect = "ask";
            })
            (lib.singleton {
              action = "external_directory";
              resource = "/tmp/*";
              effect = "deny";
            })
            (opencodeLib.mkExternalDirectoryPermissions {
              path = permissionsScratchDir;
              action = "edit";
            })
            (opencodeLib.mkExternalDirectoryPermissions {
              path = "/nix/store/*";
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
        ))

        (lib.mkAfter (
          lib.flatten [
            (lib.map
              (resource: {
                action = "read";
                inherit resource;
                effect = "deny";
              })
              [
                "*.env"
                "*.env.*"
              ]
            )

          ]
        ))
      ];

      plugins = [
        "oh-my-opencode-slim@3.0.7" # 3.0.8 requires Opencode 2.3.0
        "@slkiser/opencode-quota@latest"
        {
          package = "opencode-handoff@latest";
          options = {
            attachFiles = false;
          };
        }
      ];

      # DeepSeek V4.1 Flash degrades well below its advertised 1M context (~300-400K)
      # declaring 500K aligns compaction and statusline thresholds with that effective limit.
      providers = {
        "opencode-go".models."deepseek-v4.1-flash".limit.context = 500000;
      };
    };

    cli = {
      plugins = [
        "@mohak34/opencode-notifier"
        "-opencode.notifications"
        "@rashidrazak/opencode-status-line"
        "-opencode.sidebar.context"
        "-opencode.prompt.footer"
      ];
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
        Start with the relevant code rather than reading whole files by default.
        For changes where project conventions or existing solutions matter, search for analogous implementations and relevant tests.
        Read more context whenever it would improve the decision.

        ## Uncertainty
        Ask when you can't tell which outcome I want, or when a decision would be hard to undo. Don't ask about routine implementation details.
        Say plainly when you haven't verified something, instead of presenting it as fact.
        Ask all your questions in one batch, not one at a time.

        ## Code comments
        Default to no new comments; keep existing ones. Add a comment only for a
        non-obvious constraint, invariant, workaround, or tradeoff that the code
        cannot express and that would otherwise risk a future bug. Never restate
        what the code does, the task, or the diff — explain changes in your reply
        instead.

        ## Temporary scratch directory
        Work in a per-session subdirectory of the scratch root, created with `mktemp -d "${scratchDir}/session.XXXXXX"`;
        never write into the root itself and don't delete it. Contents are disposable, non-secret, and gone when the session
        ends — put anything persistent in the project or an explicitly requested location.

        ## Filesystem scope
        Work inside the project directory. The approved scratch directory above is an exception; before touching any other path outside the project, name the exact path and ask.
        If a command is blocked or a path is refused, stop and ask — do not look for another way to reach it.
      '')
    ];
  };
}
