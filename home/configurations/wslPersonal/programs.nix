{
  lib,
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
    java.enable = true;
    keychain.keys = [
      "id_main"
      gpgKey
    ];

    # See https://1password.community/discussion/comment/673567/#Comment_673567
    #LINK - packages/wsl-1password-cli/default.nix
    zsh.initContent = lib.mkOrder 1200 ''
      if command -v op &>/dev/null; then
       eval "$(op completion zsh 2>/dev/null || true)"
       compdef _op op
      fi
    '';
  };
}
