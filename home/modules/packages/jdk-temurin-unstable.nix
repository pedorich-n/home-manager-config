{ config, pkgs, pkgs-unstable, ... }:
{
  home.packages = with pkgs-unstable; [ temurin-jre-bin ];
}