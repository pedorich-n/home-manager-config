{
  config,
  pkgs,
  ...
}:
{
  programs = {
    claude-code.enable = true;
    direnv.enable = true;
    gh = {
      enable = true;
      settings.git_protocol = "https";
    };
    mise.enable = true;
    nh.clean.dates = "monthly";
    vscode.enable = true;
    java = {
      enable = true;
      package = pkgs.jdk17;
    };

    git = {
    };

    keychain.keys = [
      "risk_engineering"
      config.programs.git.signing.key
    ];
  };
}
