{
  lib,
  ...
}:
{
  custom.programs.hunk = {
    enable = lib.mkDefault true;

    settings = {
      agent_notes = lib.mkDefault true;

      vcs.watch = lib.mkDefault true;
    };
  };
}
