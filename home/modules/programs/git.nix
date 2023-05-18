{ pkgs, config, customLib, ... }:
{
  home.sessionVariables = {
    DELTA_PAGER = "less -R";
    LESS = "";
  };

  programs.git = {
    package = pkgs.git;

    userName = "Nikita Pedorich";
    userEmail = "pedorich.n@gmail.com";

    signing.signByDefault = customLib.nonEmpty config.programs.git.signing.key;

    delta = {
      enable = true;
      options = {
        features = "zenburst";
      };
    };

    extraConfig = {
      pull.rebase = true;
      push.default = "simple";
    };

    ignores = config.custom.misc.globalIgnores or [ ];
  };
}
