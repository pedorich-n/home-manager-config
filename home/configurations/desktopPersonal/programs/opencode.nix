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

    settings = {
      instructions = [
        "/opencode/instructions/*.md"
      ];
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
