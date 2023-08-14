{ pkgs, lib, config, ... }:
with lib;
let
  cfg = config.custom.programs.rust;
in
{
  ###### interface
  options = {
    custom.programs.rust = {
      enable = mkEnableOption "Rust";
    };
  };


  ###### implementation
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      # Default toolchain includes: cargo, clippy, rustc, rust-std, rust-docs, rustfmt
      (rust-bin.stable.latest.default.override {
        extensions = [ "rust-src" ];
      })
    ];
  };
}
