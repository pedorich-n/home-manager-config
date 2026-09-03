{
  pkgs,
  lib,
  ...
}:
let
  uvx = lib.getExe' pkgs.uv "uvx";
in
{
  programs.mcp = {
    enable = lib.mkDefault true;

    servers = {
      nix = {
        enabled = lib.mkDefault true;
        command = lib.getExe pkgs.mcp-nixos;
      };

      fetch = {
        enabled = lib.mkDefault true;
        command = uvx;
        args = [ "mcp-server-fetch" ];
      };
    };
  };
}
