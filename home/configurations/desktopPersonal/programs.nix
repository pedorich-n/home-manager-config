{
  pkgs,
  ...
}:
let
  gpgKey = "ADC7FB37D4DF4CE2";
in
{
  programs = {
    git = {
      settings.user = {
        name = "Nikita Pedorich";
        email = "pedorich.n@gmail.com";
      };

      signing = {
        format = "openpgp";
        key = gpgKey;
        signByDefault = true;
      };
    };
    gh.enable = true;
    java = {
      enable = true;
      package = pkgs.jre;
    };
    keychain.keys = [
      "id_main"
      gpgKey
    ];
    mise.enable = true;
    obsidian.enable = true;
    plasma.enable = true;
    rclone.enable = true;
    vscode.enable = true;
  };
}
