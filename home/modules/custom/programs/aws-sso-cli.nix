{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom.programs.aws-sso-cli;
in
{
  options = {
    custom.programs.aws-sso-cli = {
      enable = lib.mkEnableOption "AWS SSO CLI";

      package = lib.mkPackageOption pkgs "aws-sso-cli" { };

      enableBashIntegration = lib.hm.shell.mkBashIntegrationOption { inherit config; };

      enableZshIntegration = lib.hm.shell.mkZshIntegrationOption { inherit config; };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];

    programs = {
      bash.initExtra = lib.mkIf cfg.enableBashIntegration ''
        eval "$(${lib.getExe cfg.package} setup completions --source --shell=bash)"
      '';

      zsh.initContent = lib.mkIf cfg.enableZshIntegration ''
        eval "$(${lib.getExe cfg.package} setup completions --source --shell=zsh)"
      '';
    };

  };

}
