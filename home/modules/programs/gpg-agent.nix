{ self, lib, config, ... }:
with lib;
let
  cfg = config.custom.config.gpg-agent;
in
{
  ###### interface
  options = {
    custom.config.gpg-agent = {
      enable = mkEnableOption "";
    };
  };


  ###### implementation
  config = mkIf cfg.enable {
    home.file = {
      ".gnupg/gpg-agent.conf".text = builtins.readFile "${self}/dotfiles/.gnupg/gpg-agent.conf";
    };
  };
}
