{
  config,
  lib,
  ...
}:
{
  home = {
    homeDirectory = lib.mkDefault "/Users/${config.home.username}";
  };
}
