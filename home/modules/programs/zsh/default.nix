{ pkgs, zsh-snap, ... }:

{
  programs.zsh = {
    enable = true;

    history = {
      ignoreDups = true;
      ignoreSpace = true;
    };

    envExtra = ''
      VISUAL=vim
      EDITOR="$VISUAL"
      HOSTNAME=$(hostname)
    '';

    initExtraBeforeCompInit = (builtins.readFile ./env_default.sh);

    initExtra = (builtins.readFile ./zshrc_extra.zsh) + "\n\n" +
      (builtins.replaceStrings [ "%zsh-snap%" ] [ "${zsh-snap}" ] (builtins.readFile ./zsh_snap.zsh));
  };
}
