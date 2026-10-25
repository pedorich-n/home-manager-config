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
        rw = path: try-rw-bind (noescape (quoted path)) (noescape (quoted path));
        ro = path: try-ro-bind (noescape (quoted path)) (noescape (quoted path));
      };

      set = name: value: set-env name (noescape (quoted value));
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
      (bind.rw "$XDG_RUNTIME_DIR/opencode")
      (add-path (quoted "$HOME/.nix-profile/bin"))

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
    ++ (extraPermissions (combinators // { inherit bind quoted set; }))
    # Mount CWD as r/w as the very last step to ensure it has the highest priority
    ++ [ mount-cwd ];

  unjailed =
    pkgs.runCommand "opencode-unjailed-${opencode.version}"
      {
        inherit (opencode) version;
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
  inherit (opencode) version;

  name = "opencode-jail-${opencode.version}";
  passthru = (old.passthru or { }) // {
    inherit unjailed;
  };
})
