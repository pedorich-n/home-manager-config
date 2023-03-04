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

    extraConfig = {
      pull.rebase = true;
      push.default = "simple";
    };

    ignores = [
      ".vscode/"
      ".bloop/"
      ".metals/"
      "metals.sbt"
    ];
  };
}
