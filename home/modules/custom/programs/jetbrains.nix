{ self, pkgs, lib, config, ... }:
with lib;
let
  cfg = config.custom.programs.jetbrains;
  cfgJdk = config.custom.programs.jdk;

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
      maven = if cfgJdk.enable then pkgs.maven.override { jdk = cfgJdk.package; } else pkgs.maven;
      ideaPackage = pkgs.jetbrains.idea-community.override { inherit maven; };

      copilotAgentStorePath = getBin pkgs.github-copilot-intellij-agent;
      copilotAgentExePath = getExe pkgs.github-copilot-intellij-agent;

      copilotAgentBinRelativePath = strings.unsafeDiscardStringContext (builtins.replaceStrings [ "${copilotAgentStorePath}/" ] [ "" ] copilotAgentExePath);
    in
    mkIf enabled {
      home.packages = [ ideaPackage ];
      xdg = {
        configFile."ideavim/ideavimrc".text = builtins.readFile "${self}/dotfiles/.ideavimrc";
        dataFile."JetBrains/IdeaIC${getJetbrainsVersion ideaPackage}/github-copilot-intellij/copilot-agent/${copilotAgentBinRelativePath}" = {
          source = copilotAgentExePath;
          force = true;
        };
      };
    };
}
