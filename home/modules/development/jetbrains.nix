{ self, pkgs, lib, config, ... }:
with lib;
let
  cfg = config.custom.programs.jetbrains;

  ideaSubmodule = types.submodule {
    options = {
      enable = mkEnableOption "Intellij IDEA";
    };
  };
in
{
  ###### interface
  options = {
    custom.programs.jetbrains = {
      idea = mkOption {
        type = ideaSubmodule;
        default = { };
      };
    };
  };


  ###### implementation
  config =
    let
      enabled = cfg.idea.enable;
    in
    mkIf enabled {
      home.packages = [ pkgs.jetbrains.idea-community ];
      xdg.configFile."ideavim/ideavimrc".text = builtins.readFile "${self}/dotfiles/.ideavimrc";
    };
}
