{
  pkgs,
  lib,
  ...
}:
let
  opencode = pkgs.opencode-jail.override {
    extraPermissions =
      c: with c; [
        (try-fwd-env "OPENCODE_ENABLE_EXA")
        (try-fwd-env "OPENCODE_EXPERIMENTAL_BACKGROUND_SUBAGENTS")
        (bind.ro "$HOME/Projects")
      ];
  };
in
{
  programs.opencode = {
    package = opencode;

    context = ''
      ## Sandbox
      You are running inside a sandbox. The home directory contains only the project and a few state directories;
      your dotfiles, ~/.ssh, ~/.gnupg and ~/.config/gh are not mounted, and paths that are not mounted simply do not exist.
    '';

    settings = {
      permissions = [
        {
          action = "external_directory";
          resource = "$HOME/Projects/*";
          effect = "allow";
        }
        {
          action = "read";
          resource = "$HOME/Projects/*";
          effect = "allow";
        }
      ];
    };
  };

  home.shellAliases."opencode-unjailed" = lib.getExe opencode.unjailed;
}
