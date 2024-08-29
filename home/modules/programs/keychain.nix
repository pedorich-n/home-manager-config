{ config, lib, ... }: {
  programs.keychain = {
    enableBashIntegration = lib.mkDefault true;
    enableZshIntegration = lib.mkDefault true;
    enableXsessionIntegration = lib.mkDefault true;

    agents = [ "ssh" ] ++ lib.optional config.services.gpg-agent.enable "gpg";
  };
}
