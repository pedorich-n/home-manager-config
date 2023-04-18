{ pkgs, ... }:
let
  gpgKey = "900C2FE784D62F8C";
in
{
  imports = [ ./common-linux.nix ];

  home.username = "mykytapedorich";

  custom = {
    hm.name = "linuxWork";

    development.environments = {
      jdk.enable = true;

      scala = {
        enable = true;
        version = "2.13";
      };

      rust = {
        enable = true;
        version = "nightly";
      };

      python.enable = true;

      aliases.additionalPackages = {
        "java-8" = pkgs.jdk8;
      };
    };

    programs = {
      zsh = {
        enable = true;
        keychainIdentities = [ "work/paidy" gpgKey ];
      };

      pyenv.shellIntegrations = {
        # bash.enable = true;
        zsh.enable = true;
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
    saml2aws
    sublime4
    pyenv
    tfenv
  ]) ++ (with pkgs.gnomeExtensions; [
    date-menu-formatter
    lock-keys
    notification-timeout
    workspace-switcher-manager
  ]);
}
