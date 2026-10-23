{
  pkgs,
  lib,
  ...
}:
{
  # LINK - home/presets/ai/programs/opencode.nix
  launchd.agents = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
    opencode-scratch-dir = {
      domain = "user";
      enable = true;
      config = {
        ProgramArguments = [
          "/bin/sh"
          "-c"
          ''scratch_dir="$(/usr/bin/getconf DARWIN_USER_TEMP_DIR)opencode"; /bin/mkdir -p -m 700 "$scratch_dir" && /bin/chmod 700 "$scratch_dir"''
        ];
        RunAtLoad = true;
      };
    };
  };
}
