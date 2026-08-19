{
  pkgs,
  ...
}:
let
  gpgKey = "E3763F185F33AEA7";
in
{
  programs = {
    claude-code.enable = true;
    direnv.enable = true;
    gh.enable = true;
    mise.enable = true;
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

    zellij.settings.copy_command = "xclip -selection clipboard";
  };
}
