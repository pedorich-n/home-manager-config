{ config, lib, ... }:
with lib;
let
  cfg = config.home;
  cfgCustom = config.custom.hm;

  home = "/home/${cfg.username}";
  hmConfigLocation = "${cfg.homeDirectory}/.config.nix";
in
{
  imports = [ ./_shared.nix ];

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
      homeDirectory = mkDefault home;

      shellAliases = {
        hms = ''home-manager switch --flake "${hmConfigLocation}#${cfgCustom.name}"'';
        hmn = ''home-manager --flake "${hmConfigLocation}#${cfgCustom.name}" news'';
      };
    };

    programs = {
      zsh = {
        dirHashes = {
          "hmc" = hmConfigLocation;
        };

        initExtra = strings.optionalString (cfgCustom.shellNames != [ ]) ''
          nshell () {
            nix develop "${hmConfigLocation}#$1"
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
  };
}
