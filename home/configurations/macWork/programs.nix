{
  config,
  pkgs,
  ...
}:
{
  programs = {
    direnv.enable = true;
    gh = {
      enable = true;
      settings.git_protocol = "https";
    };
    mise.enable = true;
    nh.clean.dates = "monthly";
    java = {
      enable = true;
      package = pkgs.jdk17;
    };

    keychain.keys = [
      "risk_engineering"
      config.programs.git.signing.key
    ];
  };
}
