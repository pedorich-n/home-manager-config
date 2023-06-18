{ pkgs, ... }:
let
  gpgKey = "900C2FE784D62F8C";
in
{
  imports = [ ./common-linux.nix ];

  home.username = "mykytapedorich";

  custom = {
    hm.name = "linuxWork";

    programs = {
      gnome.dconf.enable = true;
      jdk.enable = true;
      rustup.enable = true;
      scala.enable = true;
      jetbrains = {
        idea.enable = true;
      };
      zellij.enable = true;
      gpg.enable = true;
      zsh = {
        enable = true;
        keychainIdentities = [ "work/paidy" gpgKey ];
      };
    };
  };

  fonts.fontconfig.enable = true;

  programs = {
    direnv.enable = true;
    vscode.enable = true;

    git = {
      enable = true;
      signing.key = gpgKey;
    };
    rtx = {
      enable = true;
      settings = {
        tools = {
          "python" = [ "3.11" ];
          "terraform" = [ "0.15" "0.12" ];
        };
      };
    };
  };

  home = {
    file.".sdks/java-8".source = pkgs.jdk8;

    shellAliases = {
      "zellij_pwd" = "zellij -s $(pwd | xargs basename)";
    };

    packages = (with pkgs; [
      (nerdfonts.override { fonts = [ "FiraCode" ]; })
      barrier
      caffeine-ng
      circleci-cli
      docker-compose
      google-chrome
      saml2aws
      slack
      sublime4
      xclip
    ]) ++ (with pkgs.python3Packages; [
      black
      cqlsh
    ]) ++ (with pkgs.gnomeExtensions; [
      date-menu-formatter
      lock-keys
      notification-timeout
      workspace-switcher-manager
    ]);
  };
}
