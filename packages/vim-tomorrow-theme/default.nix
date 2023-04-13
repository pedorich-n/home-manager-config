{ pkgs, lib, inputs }:
pkgs.vimUtils.buildVimPluginFrom2Nix {
  pname = "tomorrow-theme";
  version = inputs.tomorrow-theme-source.shortRev;
  src = "${inputs.tomorrow-theme-source}/vim";
}
