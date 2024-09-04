{ pkgs, ... }:
let
  gpgKey = "D98000B630763B21";
in
{
  imports = [ ./commonStandalone.nix ];

  home.username = "mykytapedorich";

  custom = {
    dotfiles.enable = true;
    runtimes = {
      enable = true;
      java = [ pkgs.jdk11 pkgs.jdk8 ];
    };
    programs = {
      gnome.enable = true;
      nh.configName = "linuxWork";
      rust.enable = true;
      scala.enable = true;
      jetbrains = {
        idea.enable = true;
      };
      gpg.enable = true;
      python = {
        enable = true;
        extraPackages = pythonPkgs: with pythonPkgs; [
          requests
          pandas
        ];
      };
    };
  };

  fonts.fontconfig.enable = true;

  programs = {
    direnv.enable = true;
    vscode.enable = true;
    java.enable = true;

    git = {
      userName = "Mykyta Pedorich";
      userEmail = "mykyta.pedorich@paidy.com";

      signing = {
        key = gpgKey;
        signByDefault = true;
      };
    };

    keychain.keys = [ "work/paidy" gpgKey ];

    zellij.settings.copy_command = "xclip -selection clipboard";
  };

  services = {
    flameshot.enable = true;
  };

  home = {
    shellAliases = {
      "zellij_pwd" = "zellij -s $(pwd | xargs basename)";
    };

    packages = with pkgs; [
      (nerdfonts.override { fonts = [ "FiraCode" ]; }) # IDE & terminal font
      ast-grep # A fast and polyglot tool for code searching, linting, rewriting at large scale
      caffeine-ng # Disable screensaver
      circleci-cli # CI/CD
      cqlsh # Cassandra
      docker-compose # Docker
      localsend-deb # Local file sharing
      nautilus # File manager, because Gnome's one has an issue with JSON files. See https://gitlab.gnome.org/GNOME/nautilus/-/issues/3273
      seahorse # Gnome encryption
      obsidian # Note-taking
      pinentry # GnuPG’s interface to passphrase input
      saml2aws # AWS SSO
      shfmt # Shell formatter
      slack # Messaging
      sublime4 # Text editor
      xclip # CLI Clipboard manager
    ];
  };
}
