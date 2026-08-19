{
  config,
  lib,
  ...
}:
let
  hmConfigLocation = "${config.home.homeDirectory}/home-manager-config";
in
{
  programs = {
    home-manager.enable = lib.mkDefault true;

    nh = {
      enable = lib.mkDefault true;
      homeFlake = lib.mkDefault hmConfigLocation;
    };

    zsh = {
      dirHashes = {
        hmc = lib.mkDefault hmConfigLocation;
      };
    };
  };

}
