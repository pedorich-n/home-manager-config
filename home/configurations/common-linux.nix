{ lib, config, stateVersion, ... }:
with lib;
let
  cfg = config.custom.home-linux;
in
{
  ###### interface
  options = {
    custom.home-linux = {
      username = mkOption {
        type = types.str;
        description = "Username";
      };

      keychainIdentities = mkOption {
        type = with types; nullOr (listOf str);
        default = null;
        description = "Optional list of identities to add to keychain (ssh, gpg)";
      };
    };
  };


  ###### implementation
  config = {
    home.username = cfg.username;
    home.homeDirectory = "/home/${cfg.username}";
    home.stateVersion = stateVersion;

    programs.home-manager.enable = true;
    targets.genericLinux.enable = true;
  };
}
