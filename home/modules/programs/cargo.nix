{
  lib,
  ...
}:
{
  programs.cargo = {
    settings = {
      net = {
        git-fetch-with-cli = lib.mkDefault true;
      };
    };
  };
}
