args @ { ... }:
let
  args_updated = args // {
    username = "pedorich_n";
  };
in
{
  imports = [
    (import ./common-linux.nix (args_updated))
    ../modules/programs/zsh
    ../modules/programs/git.nix
    ../modules/packages/common.nix
    ../modules/programs/pyenv.nix
    ../modules/programs/zsh-snap.nix
  ];

  custom.programs = {
    pyenv = {
      enable = true;
      shellIntegrations = {
        # bash.enable = true;
        zsh.enable = true;
      };
    };

    zsh = {
      enable = true;
      keychainIdentities = [ "id_main" ];
    };
  };

  programs = {
    git = {
      userEmail = "pedorich.n@gmail.com";
      signing.key = "ADC7FB37D4DF4CE2";
    };
  };
}
