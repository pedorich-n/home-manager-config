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
      jetbrains = {
        idea.enable = true;
      };
      rtx = {
        enable = true;
        shellIntegrations.zsh.enable = true;
        config = {
          tools = {
            "python" = [ "3.11" ];
            "terraform" = [ "0.15" "0.12" ];
          };
        };
      };

      gpg.enable = true;

      zsh = {
        enable = true;
        keychainIdentities = [ "work/paidy" gpgKey ];
      };
    };
  };

  programs = {
    bash.enable = true; # To set Home Manager's ENVs vars in .profil
    direnv.enable = true;
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
    slack
    sublime4
  ]) ++ (with pkgs.gnomeExtensions; [
    date-menu-formatter
    lock-keys
    notification-timeout
    workspace-switcher-manager
  ]);
}
