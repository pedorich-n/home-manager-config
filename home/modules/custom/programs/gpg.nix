{ pkgs, lib, config, ... }:
with lib;
let
  cfg = config.custom.programs.gpg;
in
{
  ###### interface
  options = {
    custom.programs.gpg = {
      enable = mkEnableOption "gpg";

      pinentryFlavor = mkOption {
        type = types.nullOr (types.enum pkgs.pinentry.flavors);
        default = null;
      };
    };
  };


  ###### implementation
  config = mkIf cfg.enable {

    programs.gpg = {
      package = pkgs.gnupg;
      enable = true;
    };

    services.gnome-keyring.enable = true;

    services.gpg-agent = {
      enable = true;
      # 7 days
      defaultCacheTtl = 604800;
      maxCacheTtl = 604800;
      pinentryFlavor = cfg.pinentryFlavor;
    };
  };
}
