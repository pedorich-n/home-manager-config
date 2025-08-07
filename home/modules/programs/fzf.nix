{ lib, ... }:
{
  programs.fzf = {
    enableBashIntegration = lib.mkDefault true;
    enableZshIntegration = lib.mkDefault true;
  };
}
