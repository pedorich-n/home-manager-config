{ config, lib, ... }: {
  programs.keychain = {
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableXsessionIntegration = true;

    agents = [ "ssh" ] ++ lib.optional config.services.gpg-agent.enable "gpg";
  };
}
