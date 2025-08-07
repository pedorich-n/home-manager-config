{
  pkgs,
  lib,
  config,
  ...
}:
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
      datagrip = {
        enable = mkEnableOption "DataGrip";
      };
    };
  };

  ###### implementation
  config =
    let
      plugins = [
        "164" # IdeaVim https://plugins.jetbrains.com/plugin/164-ideavim
        # "17718" # Github Copilot https://plugins.jetbrains.com/plugin/17718-github-copilot
      ];

      withDefaultPlugins = pkg: pkgs.jetbrains.plugins.addPlugins pkg plugins;
    in
    lib.mkMerge [
      (lib.mkIf cfg.idea.enable {
        home.packages = [ (withDefaultPlugins pkgs.jetbrains.idea-community-bin) ];
      })
      (lib.mkIf cfg.datagrip.enable {
        home.packages = [ (withDefaultPlugins pkgs.jetbrains.datagrip) ];
      })
    ];
}
