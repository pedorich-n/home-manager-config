{ ... }:
{
  imports = [ ./common-linux.nix ];

  home = {
    username = "root";
    homeDirectory = "/root";
  };

  custom = {
    hm.name = "linuxMinimal";
    programs = {
      zsh.keychainIdentities = [ "id_main" ];
    };
  };
}
