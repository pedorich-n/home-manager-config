{ lib, ... }:
{
  programs.direnv = {
    enableBashIntegration = lib.mkDefault true;
    enableZshIntegration = lib.mkDefault true;
  };
}
