{ pkgs, lib, config, ... }:
with lib;
let
  cfg = config.custom.programs.rustup;
in
{
  ###### interface
  options = {
    custom.programs.rustup = {
      enable = mkEnableOption "Rustup";
    };
  };


  ###### implementation
  config = mkIf cfg.enable {
    home.packages = [ pkgs.rustup ];
  };
}
