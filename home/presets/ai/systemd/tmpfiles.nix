{
  pkgs,
  lib,
  ...
}:
{
  # LINK - home/presets/ai/programs/opencode.nix
  systemd.user.tmpfiles.rules = lib.mkIf pkgs.stdenv.hostPlatform.isLinux [
    "d %t/opencode 0700 - - -"
  ];
}
