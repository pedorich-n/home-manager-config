{ pkgs, ...}:

{
  home.packages = with pkgs; [
    keychain
    curl
    htop
    vimHugeX
    bat
    ripgrep
    jq
    direnv
    tmux
    fira-code
  ];

}