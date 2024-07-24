{ pkgs, ... }:
let
  gpgKey = "900C2FE784D62F8C";
in
{
  imports = [ ./common-standalone.nix ];

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
      zsh.keychainIdentities = [ "work/paidy" gpgKey ];
    };
  };

  fonts.fontconfig.enable = true;

  programs = {
    direnv.enable = true;
    vscode.enable = true;
    java.enable = true;

    git.signing = {
      key = gpgKey;
      signByDefault = true;
    };

    zellij.settings.copy_command = "xclip -selection clipboard";
  };

  services = {
    flameshot.enable = true;
    gpg-agent.pinentryPackage = pkgs.pinentry-gnome3;
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
