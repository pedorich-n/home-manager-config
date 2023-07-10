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
      gnome.enable = true;
      jdk.enable = true;
      rust.enable = true;
      scala.enable = true;
      jetbrains = {
        idea.enable = true;
      };
      gpg.enable = true;
      zsh.keychainIdentities = [ "work/paidy" gpgKey ];
    };
  };

  fonts.fontconfig.enable = true;

  programs = {
    direnv.enable = true;
    vscode.enable = true;

    git.signing = {
      key = gpgKey;
      signByDefault = true;
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
      trilium-desktop
      xclip
    ]) ++ (with pkgs.python3Packages; [
      black
      cqlsh
    ]);
  };
}
