{
  pkgs,
  ...
}:
{
  programs.vscode = {
    enable = true;
    # VSCode itself is managed by the company software; this only forwards `code` to it and makes HM think VSCode is installed.
    package = pkgs.vscode-stub;

    profiles.default = {
      userSettings = {
        "network.meteredConnection" = "off";
      };
    };
  };

}
