{ pkgs, nixGLWrap, ... }:
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
      gpg = {
        enable = true;
        pinentryFlavor = "gnome3";
      };
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

    mise = {
      enable = true;
      globalConfig = {
        tools = {
          "python" = [ "3.11" ];
          "terraform" = [ "0.15" "0.12" ];
        };
      };
      settings = {
        experimental = true;
      };
    };
  };

  services = {
    flameshot.enable = true;
  };

  home = {
    file.".sdks/java-11".source = pkgs.jdk11;

    shellAliases = {
      "zellij_pwd" = "zellij -s $(pwd | xargs basename)";
    };

    packages = (with pkgs; [
      (nerdfonts.override { fonts = [ "FiraCode" ]; })
      (nixGLWrap google-chrome)
      (nixGLWrap slack)
      caffeine-ng
      circleci-cli
      docker-compose
      gnome.seahorse
      nixgl.nixGLIntel
      pinentry
      saml2aws
      shfmt
      sublime4
      trilium-desktop
      xclip
    ]) ++ (with pkgs.python3Packages; [
      black
      cqlsh
    ]);
  };
}
