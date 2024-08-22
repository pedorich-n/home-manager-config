{ pkgs, lib, config, ... }:
let
  cfg = config.custom.programs.rust;
in
{
  ###### interface
  options = with lib; {
    custom.programs.rust = {
      enable = mkEnableOption "Rust";
    };
  };


  ###### implementation
  config = lib.mkIf cfg.enable {
    home.packages = [
      # Default toolchain includes: cargo, clippy, rustc, rust-std, rust-docs, rustfmt
      (pkgs.rust-bin.stable.latest.default.override {
        extensions = [ "rust-src" ];
      })
    ];
  };
}
