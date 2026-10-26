{
  config,
  pkgs,
  lib,
  ...
}:
let
  uv =
    if (config.custom.programs.python.uv.enable or false) then
      config.custom.programs.python.uv.package
    else
      pkgs.uv;
  uvx = lib.getExe' uv "uvx";
in
{
  programs.mcp = {
    enable = lib.mkDefault true;

    servers = {
      # mcp-nixos is broken in nixpkgs because of https://github.com/NixOS/nixpkgs/pull/575004
      nix = {
        enabled = lib.mkDefault true;
        command = uvx;
        args = [ "mcp-nixos" ];
      };

      fetch = {
        enabled = lib.mkDefault true;
        command = uvx;
        args = [ "mcp-server-fetch" ];
      };

    };
  };
}
