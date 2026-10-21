{
  lib,
  ...
}:
{
  custom.programs.hunk = {
    enable = lib.mkDefault true;

    settings = {
      agent_notes = true;

      vcs.watch = true;
    };
  };
}
