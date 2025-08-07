{ lib, ... }:
{
  programs.zellij = {
    enableBashIntegration = lib.mkDefault false;
    enableZshIntegration = lib.mkDefault false;
  };
}
