{ config, lib, pkgs, ... }:
let
  cfg = config.custom.programs.ondir;

  entrySubmodule = lib.types.submodule {
    options = {
      type = lib.mkOption {
        type = lib.types.enum [ "enter" "leave" ];
      };

      script = lib.mkOption {
        type = lib.types.lines;
      };
    };
  };

  generatedSettings =
    let
      generateEntry = path: entry: ''
        ${entry.type} ${path}
        ${entry.script}
      '';

      generatedEntryList = lib.flatten (lib.mapAttrsToList (path: entries: lib.map (entry: generateEntry path entry) entries) cfg.config);
    in
    lib.concatLines generatedEntryList;
in
{
  options = {
    custom.programs.ondir = {
      enable = lib.mkEnableOption "Enable ondir";

      package = lib.mkPackageOption pkgs "ondir" { };

      enableBashIntegration = lib.hm.shell.mkBashIntegrationOption { inherit config; };
      enableZshIntegration = lib.hm.shell.mkZshIntegrationOption { inherit config; };

      config = lib.mkOption {
        type = lib.types.attrsOf (lib.types.listOf entrySubmodule);
        default = { };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home = {
      packages = [ cfg.package ];

      file = lib.mkIf (cfg.config != { }) {
        ".ondirrc".text = generatedSettings;
      };
    };

    # programs = {
    #   bash.initExtra = lib.optionalString cfg.enableBashIntegration ''
    #     cd() {
    #     	builtin cd "$@" && eval "`ondir \"$OLDPWD\" \"$PWD\"`"
    #     }

    #     pushd() {
    #     	builtin pushd "$@" && eval "`ondir \"$OLDPWD\" \"$PWD\"`"
    #     }

    #     popd() {
    #     	builtin popd "$@" && eval "`ondir \"$OLDPWD\" \"$PWD\"`"
    #     }

    #     # Run ondir on login
    #     eval "`ondir /`"
    #   '';

    #   zsh.initExtra = lib.optionalString cfg.enableZshIntegration ''
    #     eval_ondir() {
    #        eval "`ondir \"$OLDPWD\" \"$PWD\"`"
    #     }
    #     chpwd_functions=(eval_ondir $chpwd_functions)
    #   '';
    # };
  };
}
