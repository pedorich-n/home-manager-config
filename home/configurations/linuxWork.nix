{ config, pkgs, ... }:
let
  gpgKey = "E3763F185F33AEA7";
  hmConfigLocation = "${config.home.homeDirectory}/home-manager-config";
in
{
  imports = [ ./commonStandalone.nix ];

  home.username = "mykytapedorich";

  custom = {
    aliases.hms.configName = "linuxWork";
    dotfiles.enable = true;
    runtimes = {
      enable = true;
      java = [ pkgs.jdk11 pkgs.jdk8 ];
    };

    programs = {
      flameshot.enable = true;
      gnome.enable = true;
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
    java = {
      enable = true;
      package = pkgs.jdk17;
    };

    git = {
      userName = "Mykyta Pedorich";
      userEmail = "mykyta.pedorich@paidy.com";

      signing = {
        key = gpgKey;
        signByDefault = true;
      };
    };

    keychain.keys = [ "risk_engineering" gpgKey ];
    nh.flake = hmConfigLocation;

    zellij.settings.copy_command = "xclip -selection clipboard";

    zsh = {
      dirHashes = {
        hmc = hmConfigLocation;
      };
    };
  };

  home = {
    shellAliases = {
      "zellij_pwd" = "zellij --session $(pwd | xargs basename)";
    };

    packages = with pkgs; [
      ast-grep # A fast and polyglot tool for code searching, linting, rewriting at large scale
      caffeine-ng # Disable screensaver
      circleci-cli # CI/CD
      cqlsh # Cassandra
      docker-compose # Docker
      nerd-fonts.fira-code # IDE & terminal font
      obsidian # Note-taking
      pinentry # GnuPG’s interface to passphrase input
      postman
      saml2aws # AWS SSO
      shfmt # Shell formatter
      sublime4 # Text editor
      terraform # Infrastructure as code
      xclip # CLI Clipboard manager
    ];
  };

  # Fixes the issue with Gnome's Nautilus not opening JSON files
  # See: https://gitlab.gnome.org/GNOME/nautilus/-/issues/3273#note_2217618
  # See: https://github.com/nix-community/home-manager/issues/4955#issuecomment-2041447196
  xdg.mime.enable = false;
}
