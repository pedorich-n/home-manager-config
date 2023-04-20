{ pkgs, lib, config, ... }:
with lib;
let
  cfg = config.custom.development.environments.rust;
in
{
  ###### interface
  options = {
    custom.development.environments.rust = {
      enable = mkEnableOption "Rust";
    };
  };


  ###### implementation
  config = mkIf cfg.enable {
    home.packages = [ pkgs.rustup ];

    custom.programs.zsh.snap.fpaths = lists.optional rustEnabled { name = "_rustup"; command = "rustup completions zsh"; };
  };
}
