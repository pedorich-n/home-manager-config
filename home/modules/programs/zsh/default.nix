{ pkgs, ... }:

let
  zsh-snap = pkgs.callPackage ../../../../overlays/zsh-snap { };
in
{
  home.packages = [ zsh-snap ];
  programs.zsh = {
    enable = true;

    history = {
      ignoreDups = true;
      ignoreSpace = true;
    };

    envExtra = ''
      VISUAL=vim
      EDITOR="$VISUAL"
    '';

    initExtraBeforeCompInit = (builtins.readFile ./env_default.sh);

    initExtra = (builtins.readFile ./zshrc_extra.zsh) + "\n\n" +
      (builtins.replaceStrings [ "%zsh-snap%" ] [ "${zsh-snap}" ] (builtins.readFile ./zsh_snap.zsh));
  };
}
