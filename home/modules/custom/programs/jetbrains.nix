{ pkgs, lib, config, ... }:
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

      ideaPackage =
        let
          baseIdea = pkgs.jetbrains.idea-community-bin;
          plugins = [
            "164" # IdeaVim https://plugins.jetbrains.com/plugin/164-ideavim
            "17718" # Github Copilot https://plugins.jetbrains.com/plugin/17718-github-copilot
          ];
        in
        pkgs.jetbrains.plugins.addPlugins baseIdea plugins;
    in
    mkIf enabled {
      home.packages = [ ideaPackage ];
    };
}
