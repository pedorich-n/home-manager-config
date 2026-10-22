{
  pkgs,
  ...
}:
{
  programs.vim = {
    packageConfigurable = pkgs.vim;
  };
}
