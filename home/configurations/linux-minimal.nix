{ ... }:
{
  imports = [ ./common-linux.nix ];

  home = {
    username = "root";
    homeDirectory = "/root";
  };

  custom = {
    hm.name = "linuxWork";
    programs = {
      zsh.keychainIdentities = [ "id_main" ];
    };
  };
}
