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
    tmux
    fira-code
  ];

}