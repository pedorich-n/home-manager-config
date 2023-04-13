{ pkgs, lib, inputs }:
pkgs.vimUtils.buildVimPluginFrom2Nix {
  name = "tomorrow-theme";
  version = inputs.tomorrow-theme-source.shortRev;
  src = "${inputs.tomorrow-theme-source}/vim";
}
