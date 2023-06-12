{ nixpkgs, pkgs, config, lib, ... }:
with lib;
let
  cfg = config.home;
  cfgCustom = config.custom.hm;

  home = "/home/${cfg.username}";
  hmConfigLocation = "${home}/.config.nix";

  nixPkg = pkgs.nix;
  nixApps = with pkgs; [
    nil # NIX language server
    nix-tree # Interative NIX depdencey graph
    nixPkg # NIX itself
    nixpkgs-fmt # NIX code formatter
    python3Packages.hmd # Custom HomeManager Diff tool, built using NVM (Nix Version Diff)
  ];

  commonApps = with pkgs; [
    coreutils-full # GNU coreutils (cp, mv, whoami, echo, wc, ...)
    curl # HTTP client
    dtrx # "Do The Right Extraction" unarchiver
    fd # Fast "find" alternative (files/directories search)
    gdu # Fast disk usage analyser
    gnused # GNU Stream EDitor
    jq # Command-line JSON processor
    keychain # ssh-agent and/or gpg-agent between logins
    man # Man pages reader
    screen # GNU Screen. Terminal multiplexer
    tmux # Terminal MUtipleXor
    tree # Recursive directory listing
  ];

  # additionalCaches = {
  #   "http://nix-community.cachix.org" = "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=";
  # };
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
        NIX_PATH = "nixpkgs=${nixpkgs}";
      };

      shellAliases = {
        fd = "fd --no-require-git";

        hm = "home-manager";
        hms = "home-manager switch --flake ${hmConfigLocation}#${cfgCustom.name}";

        ll = "ls -alFh";
      };

      activation.hmd = hm.dag.entryAfter [ "linkGeneration" ] ''
        $VERBOSE_ECHO "Home Manager Generations Diff"
        $DRY_RUN_CMD ${getExe pkgs.python3Packages.hmd} --auto
      '';
    };

    programs = {
      home-manager.enable = true;

      bash.enable = true; # To set Home Manager's ENVs vars in .profile
      bat.enable = true; # Colorful `cat` replacement (text-files viewer)
      htop.enable = true; # Interactive resource monitor
      less.enable = true; # Interactive text-files viewer
      ripgrep.enable = true; # Fast grep replacement (regex search in content)
      starship.enable = true; # The minimal, blazing-fast, and infinitely customizable prompt
      tealdeer.enable = true; # Community-driven Man alternative
      vim.enable = true; # Text editor

      zsh = {
        dirHashes = {
          "hmc" = hmConfigLocation;
        };

        initExtra = strings.optionalString (cfgCustom.shellNames != [ ]) ''
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

      registry = {
        nixpkgs.flake = nixpkgs;
      };

      settings = {
        experimental-features = [ "nix-command" "flakes" ];
        log-lines = 50;
        # substituters = builtins.attrNames additionalCaches;
        # trusted-public-keys = builtins.attrValues additionalCaches;
      };
    };
  };
}
