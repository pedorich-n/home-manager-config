{
  lib,
  ...
}:
{
  programs.zellij = {
    enableBashIntegration = lib.mkDefault false;
    enableZshIntegration = lib.mkDefault false;

    settings = {
      session_serialization = lib.mkDefault false;
      stacked_pane_list = lib.mkDefault false;
    };
  };
}
