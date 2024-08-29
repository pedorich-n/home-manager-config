# Module containing common settings
{ pkgs, ... }:
{
  home = {
    stateVersion = "23.11";

    packages = with pkgs; [
      coreutils-full # GNU coreutils (cp, mv, whoami, echo, wc, ...)
      curl # HTTP client
      gdu # Fast disk usage analyser
      gnused # GNU Stream EDitor
      jq # Command-line JSON processor
      just # Handy tool to save and run project-specific commands.
      tree # Recursive directory listing
    ];

    sessionVariables = {
      PAGER = "less -R"; # Enable colors in less
      HOSTNAME = "$(hostname)";
    };

    shellAliases = {
      hm = "home-manager";
      ll = "ls --all --classify --human-readable --color --group-directories-first -l";
    };

  };

  programs = {
    home-manager.enable = true;

    bash.enable = true; # To set Home Manager's ENVs vars in .profile
    bat.enable = true; # Colorful `cat` replacement (text-files viewer)
    dircolors.enable = true; # Manage .dir_colors and set LS_COLORS
    fd.enable = true; # A simple, fast and user-friendly alternative to 'find'
    fzf.enable = true; # Command-line fuzzy finder
    git.enable = true; #  Distributed version control system
    htop.enable = true; # Interactive resource monitor
    keychain.enable = true; # ssh-agent and/or gpg-agent between logins
    less.enable = true; # Interactive text-files viewer
    man.enable = true; # Man pages reader
    ripgrep.enable = true; # Fast grep replacement (regex search in content)
    starship.enable = true; # The minimal, blazing-fast, and infinitely customizable prompt
    tealdeer.enable = true; # Community-driven Man alternative
    vim.enable = true; # Text editor
    zellij.enable = true; # A terminal workspace with batteries included
    zsh.enable = true; # Main shell
  };

  xdg.enable = true;
}
