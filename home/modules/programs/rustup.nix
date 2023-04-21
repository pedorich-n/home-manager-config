{ pkgs, lib, config, ... }:
with lib;
let
  cfg = config.custom.development.environments.rustup;
in
{
  ###### interface
  options = {
    custom.development.environments.rustup = {
      enable = mkEnableOption "Rustup";
    };
  };


  ###### implementation
  config = mkIf cfg.enable {
    home.packages = [ pkgs.rustup ];
  };
}
