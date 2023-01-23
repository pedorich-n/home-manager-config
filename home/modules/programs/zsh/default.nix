{ zsh-snap, ... }:
{
  programs.zsh = {
    enable = true;

    envExtra = ''
      VISUAL=vim
      EDITOR="$VISUAL"
      HOSTNAME=$(hostname)
    '';


    initExtraFirst = (builtins.readFile ./env_default.sh);

    initExtraBeforeCompInit = "zstyle :omz:plugins:keychain agents gpg,ssh";

    initExtra = ''
      ${(builtins.replaceStrings [ "%zsh-snap-path%" ] [ "${zsh-snap}" ] (builtins.readFile ./zsh_snap.zsh))}
      ${(builtins.readFile ./zshrc_extra.zsh)}
    '';
  };
}
