{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom.programs.hunk;

  skillsRoot = "${cfg.package}/share/skills/hunk";
in
{
  options.custom.programs.hunk = {
    enable = lib.mkEnableOption "Hunk";

    package = lib.mkPackageOption pkgs "hunk" { };

    installOpencodeSkills = lib.mkEnableOption "installing hunk's skills to OpenCode" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];

    programs.opencode.skills = lib.mkIf cfg.installOpencodeSkills {
      hunk-review = "${skillsRoot}/hunk-review";
      hunk-extensions = "${skillsRoot}/hunk-extensions";
    };
  };
}
