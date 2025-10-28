{ config, lib, ... }:
{
  home.sessionVariables = lib.mkIf config.programs.delta.enable {
    DELTA_PAGER = lib.mkDefault "less -R";
    LESS = lib.mkDefault "";
  };

  programs.delta = {
    enable = lib.mkDefault true;
    enableGitIntegration = lib.mkDefault true;

    options = lib.mkDefault {
      features = "zenburst";
    };
  };
}
