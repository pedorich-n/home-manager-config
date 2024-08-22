{ pkgs, lib, config, ... }:
let
  cfg = config.custom.programs.jetbrains;

in
{
  ###### interface
  options = with lib; {
    custom.programs.jetbrains = {
      idea = {
        enable = mkEnableOption "Intellij IDEA";
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
    lib.mkIf enabled {
      home.packages = [ ideaPackage ];
    };
}
