{ self, pkgs, lib, config, ... }:
with lib;
let
  cfg = config.custom.programs.jetbrains;

  ideaSubmodule = types.submodule {
    options = {
      enable = mkEnableOption "Intellij IDEA";
    };
  };

  getJetbrainsVersion = package: versions.majorMinor (strings.getVersion package);
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
      package = pkgs.jetbrains.idea-community;

      copilotAgentStorePath = getBin pkgs.github-copilot-intellij-agent;
      copilotAgentExePath = getExe pkgs.github-copilot-intellij-agent;

      copilotAgentBinRelativePath = strings.unsafeDiscardStringContext (builtins.replaceStrings [ "${copilotAgentStorePath}/" ] [ "" ] copilotAgentExePath);
    in
    mkIf enabled {
      home.packages = [ pkgs.jetbrains.idea-community ];
      xdg = {
        configFile."ideavim/ideavimrc".text = builtins.readFile "${self}/dotfiles/.ideavimrc";
        dataFile."JetBrains/IdeaIC${getJetbrainsVersion package}/github-copilot-intellij/copilot-agent/${copilotAgentBinRelativePath}" = {
          source = copilotAgentExePath;
          force = true;
        };
      };
    };
}
