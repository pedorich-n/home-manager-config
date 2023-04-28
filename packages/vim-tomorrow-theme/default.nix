{ pkgs, tomorrow-theme-source }:
pkgs.vimUtils.buildVimPluginFrom2Nix {
  pname = "tomorrow-theme";
  version = tomorrow-theme-source.shortRev;
  src = "${tomorrow-theme-source}/vim";
}
