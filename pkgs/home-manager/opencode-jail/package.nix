{
  inputs,
  pkgs,
  opencode, # Explicit arg, so that it's overrideable
  extraPermissions ? _: [ ],
  ...
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
        rw = path: try-rw-bind (noescape (quoted path)) (noescape (quoted path));
        ro = path: try-ro-bind (noescape (quoted path)) (noescape (quoted path));
      };

      set = name: value: set-env name (noescape (quoted value));
    in
    [
      network
      notifications
      open-urls-in-browser

      # jail.nix sets --new-session by default, which breaks TUI
      no-new-session

      mount-cwd

      # opencode's own state.
      (bind.rw "$HOME/.config/opencode")
      (bind.rw "$HOME/.local/share/opencode")
      (bind.rw "$HOME/.cache/opencode")

      (bind.ro "$HOME/.config/git")
      (bind.ro "$HOME/.nix-profile")
      (bind.rw "$HOME/.cache/nix")
      (bind.rw "$XDG_RUNTIME_DIR/opencode")
      (add-path (quoted "$HOME/.nix-profile/bin"))

      # The profile is missing a few staples an agent reaches for. The whole
      # nix store is already bound, so this only has to put them on PATH.
      (add-pkg-deps [
        pkgs.findutils
        pkgs.gnugrep
        pkgs.gawk
        pkgs.gnutar
        pkgs.which
        pkgs.file
        pkgs.wget
      ])

      (set "SHELL" pkgs.runtimeShell)
      (set "TMPDIR" "$XDG_RUNTIME_DIR")
      (set "XDG_CONFIG_HOME" "$HOME/.config")
      (set "XDG_DATA_HOME" "$HOME/.local/share")
      (set "XDG_CACHE_HOME" "$HOME/.cache")
      (set "XDG_STATE_HOME" "$HOME/.local/state")
      (try-fwd-env "XDG_RUNTIME_DIR")
      (try-fwd-env "COLORTERM")
      (try-fwd-env "EDITOR")
    ]
    ++ (extraPermissions combinators);
in
jail "opencode-jail" opencode permissions
