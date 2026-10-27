{
  inputs,
  pkgs,
  lib,
  opencode, # Explicit arg, so that it's overrideable
  extraPermissions ? _: [ ],
}:
let
  kdotool = pkgs.kdotool;

  # kdotool writes a script to a temp file and asks KWin runing on host, to read it back by path.
  # By default it tries to write to `/tmp/kdotool-XXXX`: https://github.com/jinliu/kdotool/blob/be03ce90c/src/main.rs#L707
  # But since that folder is mounted as tmpfs, the file never reaches the host.
  # So we need to point kdotool to a shared directory and make it think it's tmp.
  kdotoolShim = pkgs.writeShellApplication {
    name = "kdotool";

    runtimeInputs = [
      kdotool
    ];

    text = ''
      export TMPDIR="$HOME/.cache/opencode/kdotool"
      mkdir -p "$TMPDIR"
      exec kdotool "$@"
    '';
  };

  jail-minimal = inputs.jail-nix.lib.extend {
    inherit pkgs;

    # Lets the jail show desktop notifications and focus the terminal window
    additionalCombinators =
      c: with c; {
        desktop-notifications = compose [
          (dbus {
            talk = [
              "org.kde.KWin"
              "org.freedesktop.Notifications"
            ];
          })

          (add-pkg-deps [
            pkgs.libnotify
            kdotool
            kdotoolShim
          ])

          (try-fwd-env "KDE_SESSION_VERSION")
          (try-fwd-env "OPENCODE_NOTIFIER_WINDOW_ID")

          # Resolve the terminal window id on the host
          (add-runtime ''
            if [ -z "''${OPENCODE_NOTIFIER_WINDOW_ID:-}" ]; then
              OPENCODE_NOTIFIER_WINDOW_ID="$(${lib.getExe' kdotool "kdotool"} search --classname konsole 2>/dev/null | head -n1)"
              export OPENCODE_NOTIFIER_WINDOW_ID
            fi
          '')
        ];
      };

    # basePermissions are inherited by all sub processes inside jail, so don't leave this list empty
    basePermissions =
      c: with c; [
        # Base mounts `/bin/sh`, adds `coreutils` & `/bin` to `PATH`, etc
        # See https://git.sr.ht/~alexdavid/jail.nix/tree/5d2adebc/lib/combinators/base.nix
        base
        (readonly "/nix/store")
        fake-passwd
      ];
  };

  # See https://alexdav.id/projects/jail-nix/combinators/
  permissions =
    combinators:
    with combinators;
    let
      quoted = path: "\"${path}\"";
      noescape-quoted = v: noescape (quoted v);

      set-env-quoted = name: value: set-env name (noescape-quoted value);

      bind = {
        rw = path: try-readwrite (noescape-quoted path);
        ro = path: try-readonly (noescape-quoted path);
      };
    in
    [
      (ro-bind (lib.getExe' pkgs.bash "bash") "/bin/bash")
      (set-env "SHELL" "/bin/bash")
      (ro-bind (lib.getExe' pkgs.coreutils "env") "/usr/bin/env")
      network
      desktop-notifications
      # jail.nix sets --new-session by default, which breaks TUI
      no-new-session

      # opencode's own state.
      (bind.rw "$HOME/.config/opencode")
      (bind-pkg (noescape-quoted "$HOME/.config/opencode/service.json") (
        pkgs.writers.writeJSON "jail-opencode-service.json" {
          disabled = true;
        }
      ))
      (bind-pkg "/opencode/instructions/jail.md" (
        pkgs.writers.writeText "jail-opencode-notes.md" ''
          ## Sandbox
          You are running inside a sandbox. The home directory is a tmpfs; your
          dotfiles, ~/.ssh and ~/.gnupg are not mounted, and paths that are not
          mounted simply do not exist. /nix/store is read-only.
        ''
      ))
      (bind.rw "$HOME/.local/share/opencode")
      (bind.rw "$HOME/.cache/opencode")

      (bind.ro "$HOME/.config/git")
      (bind.ro "$HOME/.nix-profile")
      (bind.rw "$HOME/.cache/nix")
      (add-path (quoted "$HOME/.nix-profile/bin"))

      (bind-pkg "/etc/nix/nix.conf" (
        pkgs.writers.writeText "jail-opencode-nix.conf" ''
          experimental-features = nix-command flakes
        ''
      ))
      # Nix builder is outside of jail, so we need to let its socket inside
      (bind.ro "/nix/var/nix/daemon-socket/socket")

      # Some default packages expected by Opencode.
      (add-pkg-deps (
        with pkgs;
        [
          findutils
          gnugrep
          gawk
          gitMinimal
          gnutar
          which
          file
          wget
        ]
      ))

      # Used by Opencode https://github.com/anomalyco/opencode/blob/2a3e7c0f349ba0e9454fa0/packages/core/src/instructions/builtins.ts#L43
      (set-env-quoted "TMPDIR" "/tmp")
      (set-env-quoted "XDG_CONFIG_HOME" "$HOME/.config")
      (set-env-quoted "XDG_DATA_HOME" "$HOME/.local/share")
      (set-env-quoted "XDG_CACHE_HOME" "$HOME/.cache")
      (set-env-quoted "XDG_STATE_HOME" "$HOME/.local/state")
      (set-env-quoted "NIX_REMOTE" "daemon")
      (try-fwd-env "COLORTERM")
      (try-fwd-env "EDITOR")

      # A runtime hack to protect git in normal git flow as well as in worktrees
      (add-runtime ''
        common="$(git rev-parse --git-common-dir 2>/dev/null || true)"
        if [ -n "$common" ]; then
          common="$(realpath "$common" 2>/dev/null || printf %s "$common")"
          for part in config hooks modules; do
            if [ -e "$common/$part" ]; then
              RUNTIME_ARGS+=(--ro-bind-try "$common/$part" "$common/$part")
            fi
          done
        fi

        if [ -f "$PWD/.git" ]; then
          RUNTIME_ARGS+=(--ro-bind-try "$PWD/.git" "$PWD/.git")
        fi
      '')

      # Defer mounting CWD until the very end to ensure it has the highest priority
      (defer mount-cwd)
    ]
    ++ (extraPermissions (
      combinators
      // {
        inherit
          bind
          quoted
          noescape-quoted
          set-env-quoted
          ;
      }
    ));

  version = lib.getVersion opencode;

in
(jail-minimal "opencode" opencode permissions).overrideAttrs (old: {
  pname = "opencode-jail";
  inherit version;

  name = "opencode-jail-${version}";
  passthru = (old.passthru or { }) // {
    unjailed = opencode;
  };
})
