{
  pkgs,
  lib,
  ...
}:
let
  uv = pkgs.uv;
in
{
  programs.mcp = {
    servers = {
      nix = {
        enabled = lib.mkDefault true;
        command = lib.getExe pkgs.mcp-nixos;
      };

      fetch = {
        enabled = lib.mkDefault true;
        command = lib.getExe' uv "uvx";
        args = [ "mcp-server-fetch" ];
      };
    };
  };
}
