{ pkgs, ...}:

{
  home.packages = with pkgs; [
    curl
    htop
    vimHugeX
    bat
    jq
    tmux
    fira-code
  ];

}