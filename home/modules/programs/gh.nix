{
  lib,
  ...
}:
{
  programs.gh = {
    settings = {
      git_protocol = lib.mkDefault "ssh";
    };
  };
}
