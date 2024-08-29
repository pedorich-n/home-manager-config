{ pkgs, config, lib, ... }:
{
  home.sessionVariables = lib.mkIf config.programs.git.enable {
    DELTA_PAGER = lib.mkDefault "less -R";
    LESS = lib.mkDefault "";
  };

  programs.git = {
    package = lib.mkDefault pkgs.git;

    delta = {
      enable = lib.mkDefault true;
      options = lib.mkDefault {
        features = "zenburst";
      };
    };

    extraConfig = lib.mkDefault {
      pull.rebase = true;
      push.default = "simple";
      submodule.recurse = true;
    };

    ignores = config.custom.misc.globalIgnores or [ ];
  };
}
