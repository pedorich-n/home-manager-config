{ lib, ... }:
{
  programs.nh = {
    clean = {
      enable = lib.mkDefault true;
      dates = lib.mkDefault "*-*-01,14 11:00:00"; # On the 1st and 14th of every month at 11:00
      extraArgs = lib.mkDefault "--keep 3 --keep-since 30d"; # Keep last 3 generations/generations younger than 30 days
    };
  };
}
