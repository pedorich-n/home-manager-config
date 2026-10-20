{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.custom.programs.hunk;

  skillsRoot = "${cfg.package}/share/skills/hunk";

  tomlFormat = pkgs.formats.toml { };
in
{
  options.custom.programs.hunk = {
    enable = lib.mkEnableOption "Hunk";

    package = lib.mkPackageOption pkgs "hunk" { };

    installOpencodeSkills = lib.mkEnableOption "installing hunk's skills to OpenCode" // {
      default = true;
    };

    settings = lib.mkOption {
      inherit (tomlFormat) type;
      default = { };
      description = ''
        Settings for the `hunk` config, written to
        {file}`$XDG_CONFIG_HOME/hunk/config.toml`.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];

    programs.opencode.skills = lib.mkIf cfg.installOpencodeSkills {
      hunk-review = "${skillsRoot}/hunk-review";
      hunk-extensions = "${skillsRoot}/hunk-extensions";
    };

    xdg.configFile = lib.mkIf (cfg.settings != { }) {
      "hunk/config.toml".source = tomlFormat.generate "hunk-config.toml" cfg.settings;
    };
  };
}
