{
  config,
  lib,
  opencodeLib,
  pkgs,
  ...
}:
let
  # kdotool writes a script to a temp file and asks KWin running on host to read
  # it back by path. The jail's /tmp is a tmpfs, so point kdotool at a shared
  # directory and make it think it's tmp.
  kdotoolShim = pkgs.writeShellApplication {
    name = "kdotool";

    runtimeInputs = [
      pkgs.kdotool
    ];

    text = ''
      export TMPDIR="$HOME/.cache/opencode/kdotool"
      mkdir -p "$TMPDIR"
      exec kdotool "$@"
    '';
  };

  opencode = pkgs.opencode-jail.override {
    extraGitSettings = {
      inherit (config.programs.git.settings) credential pull submodule;
    };

    extraPermissions =
      c: with c; [
        (try-fwd-env "OPENCODE_ENABLE_EXA")
        (try-fwd-env "OPENCODE_EXPERIMENTAL_BACKGROUND_SUBAGENTS")
        (bind.try-ro "$HOME/Projects")
        (bind.try-rw "$HOME/.local/share/plannotator")
        (add-pkg-deps [
          config.programs.gh.package
          pkgs.plannotator
        ])

        (try-ro-bind config.sops.templates."github/opencode-hosts.yml".path (noescape-quoted "$HOME/.config/gh/hosts.yml"))

        (bind-pkg "/opencode/instructions/github.md" (
          pkgs.writers.writeText "jail-opencode-github-notes.md" ''
            ## GitHub access

            `gh` is installed and authenticated as `pedorich-n` with a token that has read-only access to Github.
          ''
        ))

        # KDE: desktop notifications and focusing the terminal window
        (compose [
          (dbus {
            talk = [
              "org.kde.KWin"
              "org.freedesktop.Notifications"
            ];
          })
          (add-pkg-deps [
            pkgs.libnotify
            pkgs.kdotool
            kdotoolShim
          ])
          (try-fwd-env "KDE_SESSION_VERSION")
          (try-fwd-env "OPENCODE_NOTIFIER_WINDOW_ID")

          # Resolve the terminal window id on the host
          (add-runtime ''
            if [ -z "''${OPENCODE_NOTIFIER_WINDOW_ID:-}" ]; then
              OPENCODE_NOTIFIER_WINDOW_ID="$(${lib.getExe' pkgs.kdotool "kdotool"} search --classname konsole 2>/dev/null | head -n1)"
              export OPENCODE_NOTIFIER_WINDOW_ID
            fi
          '')
        ])
      ];
  };

in
{
  xdg.configFile = {
    "opencode/opencode-notifier.json".source = pkgs.writers.writeJSON "opencode-notifier.json" {
      notification = true;
      sound = false;
      bell = false;
      focusOnClick = false;
      suppressWhenFocused = true;
      timeout = 5;
      showProjectName = false;
      showSessionTitle = false;

      onClickCommand = {
        enabled = false;
      };

      events = {
        permission = {
          sound = false;
          notification = true;
          bell = false;
        };
        complete = {
          sound = false;
          notification = true;
          bell = false;
        };
        error = {
          sound = false;
          notification = true;
          bell = false;
        };
        question = {
          sound = false;
          notification = true;
          bell = false;
        };
      };
    };
  };

  programs.opencode = {
    package = opencode;

    settings = {
      plugins = [
        "@plannotator/opencode@latest"
      ];
      instructions = [
        "/opencode/instructions/*.md"
      ];
      permissions = lib.flatten [
        (opencodeLib.mkExternalDirectoryPermissions {
          path = "/opencode/*";
        })
        (opencodeLib.mkExternalDirectoryPermissions {
          path = "$HOME/Projects/*";
        })
      ];
    };
  };

  home.shellAliases."opencode-unjailed" = lib.getExe opencode.unjailed;
}
