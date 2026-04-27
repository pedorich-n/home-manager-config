{
  tomorrow-theme-source,
  pkgs,
}:
pkgs.vimUtils.buildVimPlugin {
  pname = "tomorrow-theme";
  version = tomorrow-theme-source.shortRev;
  src = "${tomorrow-theme-source}/vim";
}
