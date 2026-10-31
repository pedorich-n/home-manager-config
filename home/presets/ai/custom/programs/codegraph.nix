{
  lib,
  ...
}:
{
  custom.programs.codegraph = {
    enable = lib.mkDefault true;
    mcp.enable = lib.mkDefault true;
  };
}
