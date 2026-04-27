{
  inputs,
  pkgs,
}:
pkgs.vimUtils.buildVimPlugin {
  pname = "tomorrow-theme";
  version = inputs.tomorrow-theme-source.shortRev;
  src = "${inputs.tomorrow-theme-source}/vim";
}
