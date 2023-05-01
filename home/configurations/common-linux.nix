{ pkgs, config, lib, customLib, ... }:
with lib;
let
  cfg = config.home;
  cfgCustom = config.custom.hm;

  home = "/home/${cfg.username}";
  hmConfigLocation = "${home}/.config.nix";

  nixPkg = pkgs.nix;
  nixApps = with pkgs; [
    nix-tree
    nixPkg
    nixpkgs-fmt
    nvd
    rnix-lsp
  ];

  commonApps = with pkgs; [
    coreutils-full
    curl
    # dtrx
    gdu
    gnused
    jq
    keychain
    man
    ripgrep
    screen
    tmux
    tree
  ];
in
{
  ###### interface
  options = {
    custom.hm = {
      name = mkOption {
        type = types.str;
        description = "Home-Manager Flake Configuration name; Used in alias for `home-manager switch #name`";
      };

      shellNames = mkOption {
        type = with types; listOf str;
        description = "List of nix develop shell names, from devShells in flake.nix";
      };
    };
  };

  ###### implementation
  config = {
    home = {
      stateVersion = "22.11";

      homeDirectory = home;

      packages = nixApps ++ commonApps;

      sessionVariables = {
        PAGER = "less -R";
        HOSTNAME = "$(hostname)";
      };

      shellAliases = {
        hm = "home-manager";
        hms = "home-manager switch --flake ${hmConfigLocation}#${cfgCustom.name}";
        hmd = "python ${hmConfigLocation}/hmd.py";

        ll = "ls -alFh";
      };
    };

    custom = {
      programs = {
        fd.enable = true;
      };
    };

    programs = {
      home-manager.enable = true;

      bash.enable = true; # To set Home Manager's ENVs vars in .profile
      bat.enable = true;
      htop.enable = true;
      less.enable = true;
      tealdeer.enable = true;
      vim.enable = true;


      zsh = {
        dirHashes = {
          "hmc" = hmConfigLocation;
        };

        initExtra = strings.optionalString (customLib.nonEmpty cfgCustom.shellNames) ''
          nshell () {
            nix develop ${hmConfigLocation}#$1
          }
          _nshell () {
            local -a args=(
              '1: :(${builtins.concatStringsSep " " cfgCustom.shellNames})'
            )
            _arguments $args
          }
          compdef _nshell nshell
        '';
      };
    };

    targets.genericLinux.enable = true;

    nix = {
      package = nixPkg;

      settings = {
        experimental-features = [ "nix-command" "flakes" ];
        log-lines = 50;
      };
    };
  };
}
