{ lib, ... }:
{
  programs.keychain = {
    enableBashIntegration = lib.mkDefault true;
    enableZshIntegration = lib.mkDefault true;
    enableXsessionIntegration = lib.mkDefault true;
  };
}
