{ pkgs, ... }:

{
  home.packages = with pkgs; [
    keychain
    curl
    htop
    bat
    ripgrep
    jq
    direnv
    tmux
    fira-code
  ];

}
