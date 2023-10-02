{ pkgs, tomorrow-theme-source }:
pkgs.vimUtils.buildVimPlugin {
  pname = "tomorrow-theme";
  version = tomorrow-theme-source.shortRev;
  src = "${tomorrow-theme-source}/vim";
}
