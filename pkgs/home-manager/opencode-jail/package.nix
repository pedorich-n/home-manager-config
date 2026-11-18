{
  inputs,
  pkgs,
  lib,
  opencode, # Explicit arg, so that it's overrideable
  extraPermissions ? _: [ ],
  extraGitSettings ? { },
}:
let
  stdenv = pkgs.stdenv;
  dynamicLinker = stdenv.cc.bintools.dynamicLinker;
  # Where prebuilt binaries expect the ELF loader (e.g. `/lib64/ld-linux-x86-64.so.2`)
  # Adapted from https://github.com/NixOS/nixpkgs/blob/6b93cd12c87540c01762ba068f30928f4f916954/nixos/modules/config/ldso.nix#L17-L20
  ldsoPath = "/${stdenv.hostPlatform.libDir}/${baseNameOf dynamicLinker}";

  jail-minimal = inputs.jail-nix.lib.extend {
    inherit pkgs;

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
        try-rw = path: try-readwrite (noescape-quoted path);
        try-ro = path: try-readonly (noescape-quoted path);
      };

      environment = compose [
        (ro-bind (lib.getExe' pkgs.bash "bash") "/bin/bash")
        (ro-bind (lib.getExe' pkgs.coreutils "env") "/usr/bin/env")
        (set-env "SHELL" "/bin/bash")

        (set-env-quoted "TMPDIR" "/tmp")

        (set-env-quoted "XDG_CONFIG_HOME" "$HOME/.config")
        (set-env-quoted "XDG_DATA_HOME" "$HOME/.local/share")
        (set-env-quoted "XDG_CACHE_HOME" "$HOME/.cache")
        (set-env-quoted "XDG_STATE_HOME" "$HOME/.local/state")

        (try-fwd-env "OPENCODE_CONFIG")
        (try-fwd-env "OPENCODE_TUI_CONFIG")
        (try-fwd-env "OPENCODE_CLI_CONFIG_CONTENT")
        (try-fwd-env "OPENCODE_CONFIG_DIR")
      ];

      # Downloaded (non-Nix) binaries hardcode the FHS loader path as their
      # interpreter, but the store glibc loader does not search it.
      # nix-ld bridges that by handing the store loader an explicit lib path.
      nix-ld = compose [
        (ro-bind "${pkgs.nix-ld}/libexec/nix-ld" ldsoPath)
        (set-env-quoted "NIX_LD" dynamicLinker)
        (set-env-quoted "NIX_LD_LIBRARY_PATH" (
          lib.makeLibraryPath (
            with pkgs;
            [
              bzip2
              curl
              gcc-unwrapped.lib
              glibc
              openssl
              xz
              zlib
              zstd
            ]
          )
        ))
      ];

      # Host services the agent talks to, and the terminal it runs in.
      session = compose [
        network
        no-new-session # jail.nix sets --new-session by default, which breaks TUI
        (try-fwd-env "COLORTERM")
        (try-fwd-env "EDITOR")
        (try-fwd-env "VISUAL")
      ];

      # Everything opencode itself reads and writes.
      opencodeState = compose [
        (bind.try-rw "$HOME/.config/opencode")
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
        (bind.try-rw "$HOME/.local/share/opencode")
        (bind.try-rw "$HOME/.cache/opencode")
      ];

      git = compose [
        (bind.try-ro "$HOME/.config/git/ignore")
        (bind-pkg (noescape-quoted "$HOME/.config/git/config") (
          pkgs.writeText "jail-opencode-git-config" ''
            ${lib.generators.toGitINI (
              {
                url."https://github.com/".insteadOf = [
                  "git@github.com:"
                  "ssh://git@github.com/"
                ];
              }
              // extraGitSettings
            )}
          ''
        ))

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
      ];

      nixCli = compose [
        (bind.try-ro "$HOME/.nix-profile")
        (bind.try-rw "$HOME/.cache/nix")
        (add-path (quoted "$HOME/.nix-profile/bin"))
        (bind-pkg "/etc/nix/nix.conf" (
          pkgs.writers.writeText "jail-opencode-nix.conf" ''
            experimental-features = nix-command flakes
          ''
        ))
        # Nix builder is outside of jail, so we need to let its socket inside
        (bind.try-ro "/nix/var/nix/daemon-socket/socket")
        (set-env-quoted "NIX_REMOTE" "daemon")
      ];

      # Some default packages expected by Opencode.
      cliTools = compose [
        (add-pkg-deps (
          with pkgs;
          [
            # keep-sorted start
            binutils
            curl
            diffutils
            file
            findutils
            gawk
            gitMinimal
            gnugrep
            gnutar
            gzip
            patch
            unzip
            wget
            which
            xz
            # keep-sorted end
          ]
        ))
      ];
    in
    [
      environment
      nix-ld
      session
      opencodeState
      git
      nixCli
      cliTools

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

  buildCommand = (old.buildCommand or "") + ''
    mkdir -p $out/share
    ln -s ${opencode}/share/bash-completion $out/share/bash-completion
    ln -s ${opencode}/share/zsh $out/share/zsh
  '';

  passthru = (old.passthru or { }) // {
    unjailed = opencode;
  };
})
