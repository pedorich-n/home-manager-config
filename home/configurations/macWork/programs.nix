{
  pkgs,
  ...
}:
let
  gpgKey = "BB80A0D1C0EF81CD";
in
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
      settings.user = {
        name = "Mykyta Pedorich";
        email = "mykyta.pedorich@paidy.com";
      };

      signing = {
        format = "openpgp";
        key = gpgKey;
        signByDefault = true;
      };
    };

    keychain.keys = [
      "risk_engineering"
      gpgKey
    ];
  };
}
