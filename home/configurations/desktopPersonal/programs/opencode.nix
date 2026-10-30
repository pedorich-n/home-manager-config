{
  config,
  lib,
  opencodeLib,
  pkgs,
  ...
}:
let
  opencode = pkgs.opencode-jail.override {
    extraPermissions =
      c: with c; [
        (try-fwd-env "OPENCODE_ENABLE_EXA")
        (try-fwd-env "OPENCODE_EXPERIMENTAL_BACKGROUND_SUBAGENTS")
        (bind.try-ro "$HOME/Projects")
        (add-pkg-deps (
          with pkgs;
          [
            gh
          ]
        ))

        (try-ro-bind config.sops.templates."github/opencode-hosts.yml".path (noescape-quoted "$HOME/.config/gh/hosts.yml"))
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
