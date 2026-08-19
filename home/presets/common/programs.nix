{
  lib,
  ...
}:
{
  programs = {
    bash.enable = lib.mkDefault true; # To set Home Manager's ENVs vars in .profile
    bat.enable = lib.mkDefault true; # Colorful `cat` replacement (text-files viewer)
    dircolors.enable = lib.mkDefault true; # Manage .dir_colors and set LS_COLORS
    fd.enable = lib.mkDefault true; # A simple, fast and user-friendly alternative to 'find'
    fzf.enable = lib.mkDefault true; # Command-line fuzzy finder
    git.enable = lib.mkDefault true; # Distributed version control system
    htop.enable = lib.mkDefault true; # Interactive resource monitor
    keychain.enable = lib.mkDefault true; # ssh-agent and/or gpg-agent between logins
    less.enable = lib.mkDefault true; # Interactive text-files viewer
    man.enable = lib.mkDefault true; # Man pages reader
    ripgrep.enable = lib.mkDefault true; # Fast grep replacement (regex search in content)
    starship.enable = lib.mkDefault true; # The minimal, blazing-fast, and infinitely customizable prompt
    tealdeer.enable = lib.mkDefault true; # Community-driven Man alternative
    vim.enable = lib.mkDefault true; # Text editor
    zellij.enable = lib.mkDefault true; # A terminal workspace with batteries included
    zsh.enable = lib.mkDefault true; # Main shell
  };
}
