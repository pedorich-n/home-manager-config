args @ { zsh-snap, ... }:
let
  keychain-identities =
    if args?identities && args.identities != [ ]
    then ''
      zstyle :omz:plugins:keychain agents gpg,ssh
      zstyle :omz:plugins:keychain identities ${(builtins.concatStringsSep " " args.identities)}
    ''
    else "";
in
{
  programs.zsh = {
    enable = true;

    envExtra = ''
      VISUAL=vim
      EDITOR="$VISUAL"
      HOSTNAME=$(hostname)
    '';


    initExtraFirst = (builtins.readFile ./env_default.sh);

    initExtraBeforeCompInit = keychain-identities;

    initExtra = ''
      ${(builtins.replaceStrings [ "%zsh-snap-path%" ] [ "${zsh-snap}" ] (builtins.readFile ./zsh_snap.zsh))}
      ${(builtins.readFile ./zshrc_extra.zsh)}
    '';
  };
}
