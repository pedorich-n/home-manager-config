{ pkgs, ...}:

{
  home.packages = with pkgs; [
    keychain
    curl
    htop
    vimHugeX
    bat
    jq
    tmux
    fira-code
  ];

}