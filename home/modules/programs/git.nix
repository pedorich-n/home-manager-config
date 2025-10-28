{
  pkgs,
  config,
  lib,
  ...
}:
{
  programs.git = {
    package = lib.mkDefault pkgs.git;

    settings = {
      pull.rebase = true;
      push.default = "simple";
      submodule.recurse = true;
    };

    ignores = config.custom.misc.globalIgnores or [ ];
  };
}
