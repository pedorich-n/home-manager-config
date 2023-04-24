{ pkgs, ... }:
let
  gpgKey = "900C2FE784D62F8C";
in
{
  imports = [ ./common-linux.nix ];

  home.username = "mykytapedorich";

  custom = {
    hm.name = "linuxWork";

    misc.sdkLinks = {
      enable = true;
      paths = {
        "java-8" = pkgs.jdk8;
      };
    };

    programs = {
      jdk.enable = true;
      rustup.enable = true;
      scala = {
        enable = true;
        version = "2.13";
      };

      zsh = {
        enable = true;
        keychainIdentities = [ "work/paidy" gpgKey ];
      };

      pyenv = {
        enable = true;
        shellIntegrations.zsh.enable = true;
      };

      jetbrains = {
        idea.enable = true;
      };
    };
  };

  programs = {
    bash.enable = true; # To set Home Manager's ENVs vars in .profile
    htop.enable = true;
    direnv.enable = true;
    vim.enable = true;
    vscode.enable = true;

    git = {
      enable = true;
      signing.key = gpgKey;
    };
  };

  home.packages = (with pkgs; [
    barrier
    caffeine-ng
    circleci-cli
    pyenv
    saml2aws
    slack
    sublime4
    tfenv
  ]) ++ (with pkgs.gnomeExtensions; [
    date-menu-formatter
    lock-keys
    notification-timeout
    workspace-switcher-manager
  ]);
}
