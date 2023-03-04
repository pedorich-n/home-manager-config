{ pkgs, lib, config, ... }:
with lib;
let
  cfg = config.custom.config.fonts;
in
{
  ###### interface
  options = {
    custom.config.fonts = {
      enable = mkEnableOption "fonts";
    };
  };


  ###### implementation
  config = mkIf cfg.enable {
    fonts.fontconfig.enable = true;
    home.packages = with pkgs; [
      # This derivation installs a Variable font (multiple fonts in a single file). Idea doesn't support these :(
      # https://youtrack.jetbrains.com/issue/JBR-3674/Variable-fonts-support
      fira-code
      fira-code-symbols

      jetbrains-mono
    ];
  };
}
