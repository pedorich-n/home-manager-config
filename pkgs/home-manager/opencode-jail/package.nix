{
  inputs,
  pkgs,
  lib,
  opencode, # Explicit arg, so that it's overrideable
  extraPermissions ? _: [ ],
}:
let
  # Just like base, but mounts swhole `/nix/store` as readable rather than just this runtime env.
  # See https://alexdav.id/projects/jail-nix/combinators/#default-included-combinators
  jail = inputs.jail-nix.lib.extend {
    inherit pkgs;
    basePermissions =
      c: with c; [
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

      bind = {
        rw = path: try-readwrite (noescape (quoted path));
        ro = path: try-readonly (noescape (quoted path));
      };

      set-env-quoted = name: value: set-env name (noescape (quoted value));
    in
    [
      network
      notifications

      # jail.nix sets --new-session by default, which breaks TUI
      no-new-session

      # opencode's own state.
      (bind.rw "$HOME/.config/opencode")
      (bind.rw "$HOME/.local/share/opencode")
      (bind.rw "$HOME/.cache/opencode")

      (bind.ro "$HOME/.config/git")
      (bind.ro "$HOME/.nix-profile")
      (bind.rw "$HOME/.cache/nix")
      (add-path (quoted "$HOME/.nix-profile/bin"))

      # Minimal config with sane defaults
      (write-text "/etc/nix/nix.conf" ''
        experimental-features = nix-command flakes
      '')
      # Nix builder is outside of jail, so we need to let its socked inside
      (bind.ro "/nix/var/nix/daemon-socket/socket")

      # Some sane defaults expected by Opencode
      (add-pkg-deps (
        with pkgs;
        [
          coreutils
          findutils
          gnugrep
          gawk
          gnutar
          which
          file
          wget
        ]
      ))

      (set-env-quoted "SHELL" pkgs.runtimeShell)
      # Used by Opencode https://github.com/anomalyco/opencode/blob/2a3e7c0f349ba0e9454fa0/packages/core/src/instructions/builtins.ts#L43
      (set-env-quoted "TMPDIR" "/tmp")
      (set-env-quoted "XDG_CONFIG_HOME" "$HOME/.config")
      (set-env-quoted "XDG_DATA_HOME" "$HOME/.local/share")
      (set-env-quoted "XDG_CACHE_HOME" "$HOME/.cache")
      (set-env-quoted "XDG_STATE_HOME" "$HOME/.local/state")
      (set-env-quoted "NIX_REMOTE" "daemon")
      (try-fwd-env "COLORTERM")
      (try-fwd-env "EDITOR")

      # Defer mounting CWD as r/w until the very to ensure it has the highest priority
      (defer (compose [
        mount-cwd
        (bind.ro "$PWD/.git/config")
        (bind.ro "$PWD/.git/hooks")
      ]))
    ]
    ++ (extraPermissions (combinators // { inherit bind quoted set-env-quoted; }));

  version = lib.getVersion opencode;

  unjailed =
    pkgs.runCommand "opencode-unjailed-${opencode.version}"
      {
        inherit version;
        meta.mainProgram = "opencode-unjailed";
      }
      ''
        mkdir -p $out/bin
        ln -s ${lib.getExe opencode} $out/bin/opencode-unjailed
      '';

in
# Using custom package rathther than jail's mkOverlay to allow extra args
(jail "opencode" opencode permissions).overrideAttrs (old: {
  pname = "opencode-jail";
  inherit version;

  name = "opencode-jail-${version}";
  passthru = (old.passthru or { }) // {
    inherit unjailed;
  };
})
