{ pkgs, lib, config, customLib, ... }:
with lib;
let
  cfg = config.programs.git;
in
{
  config.programs.git = {
    package = pkgs.git;

    userName = "Nikita Pedorich";
    userEmail = "pedorich.n@gmail.com";

    signing.signByDefault = customLib.nonEmpty cfg.signing.key;

    delta = {
      enable = true;
      options = {
        features = "zenburst";
      };
    };

    extraConfig = {
      pull.rebase = true;
      push.default = "simple";
    };

    ignores = [
      ".bloop/"
      ".metals/"
      ".venv/"
      ".vscode/"
      "metals.sbt"
      "venv/"
    ];
  };
}
