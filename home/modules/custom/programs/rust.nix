{ pkgs, lib, config, self, ... }:
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
    home.packages = [
      # Default toolchain includes: cargo, clippy, rustc, rust-std, rust-docs, rustfmt
      (pkgs.rust-bin.stable.latest.default.override {
        extensions = [ "rust-src" ];
      })
    ];

    xdg.configFile.".cargo/config.toml".text = builtins.readFile "${self}/dotfiles/.cargo/config.toml";
  };
}
