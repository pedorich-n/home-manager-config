{
  lib,
  ...
}:
{
  programs.zellij = {
    enableBashIntegration = lib.mkDefault false;
    enableZshIntegration = lib.mkDefault false;

    settings = {
      session_serialization = false;
      stacked_pane_list = false;
    };
  };
}
