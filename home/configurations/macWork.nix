{
  config,
  pkgs,
  ...
}:
let
  gpgKey = "BB80A0D1C0EF81CD";
in
{
  imports = [ ./commonStandalone.nix ];

  home = {
    username = "mpedorich";
    homeDirectory = "/Users/${config.home.username}";
  };

  custom = {
    aliases.hms.configName = "macWork";
    dotfiles.enable = true;
    runtimes = {
      enable = true;
      java = [
        pkgs.jdk11
        pkgs.jdk8
      ];
    };

    programs = {
      aws-sso-cli.enable = true;
      flameshot.enable = true;
      rust.enable = true;
      scala.enable = true;
      gpg.enable = true;
      python = {
        enable = true;
        extraPackages =
          pythonPkgs: with pythonPkgs; [
            requests
            pandas
          ];

        poetry.enable = true;
        uv.enable = true;
      };
    };
  };

  fonts.fontconfig.enable = true;

  programs = {
    claude-code.enable = true;
    direnv.enable = true;
    gh.enable = true;
    mise.enable = true;
    nh.clean.dates = "monthly";
    vscode.enable = true;
    java = {
      enable = true;
      package = pkgs.jdk17;
    };

    git = {
      settings.user = {
        name = "Mykyta Pedorich";
        email = "mykyta.pedorich@paidy.com";
      };

      signing = {
        format = "openpgp";
        key = gpgKey;
        signByDefault = true;
      };
    };

    keychain.keys = [
      "risk_engineering"
      gpgKey
    ];
  };

  home = {
    shellAliases = {
      "zellij_pwd" = "zellij --session $(pwd | xargs basename)";
    };

    packages = with pkgs; [
      awscli2 # AWS CLI
      nerd-fonts.fira-code # IDE & terminal font
      saml2aws # AWS SSO
      shfmt # Shell formatter
      opentofu
      tofu-ls
    ];
  };

  targets = {
    genericLinux.enable = false;
  };
}
