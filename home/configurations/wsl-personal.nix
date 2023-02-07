args @ { ... }:
let
  args_updated = args // {
    username = "pedorich_n";
    identities = [ "id_main" ];
  };
in
{
  imports = [
    (import ./common-linux.nix (args_updated))
    (import ../modules/programs/zsh (args_updated))
    ../modules/programs/git.nix
    ../modules/packages/common.nix
    ../modules/programs/pyenv.nix
  ];

  custom.programs = {
    pyenv = {
      enable = true;
      shellIntegrations = {
        # bash.enable = true;
        zsh.enable = true;
      };
    };
  };

  programs = {
    git = {
      userEmail = "pedorich.n@gmail.com";
      signing.key = "ADC7FB37D4DF4CE2";
    };
  };
}
