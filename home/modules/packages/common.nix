{ pkgs, ... }:

{
  home.packages = with pkgs; [
    keychain
    curl
    bat
    ripgrep
    jq
    direnv
    tmux
    fira-code
  ];

}
