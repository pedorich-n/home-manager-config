{ pkgs, config, lib, ... }:
{
  home.sessionVariables = lib.mkIf config.programs.git.enable {
    DELTA_PAGER = "less -R";
    LESS = "";
  };

  programs.git = {
    package = pkgs.git;

    userName = "Nikita Pedorich";
    userEmail = "pedorich.n@gmail.com";

    delta = {
      enable = true;
      options = {
        features = "zenburst";
      };
    };

    extraConfig = {
      pull.rebase = true;
      push.default = "simple";
      submodule.recurse = true;
    };

    ignores = config.custom.misc.globalIgnores or [ ];
  };
}
