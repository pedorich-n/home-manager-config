{
  config,
  pkgs,
  ...
}:
{
  programs.vscode = {
    enable = true;
    profiles.default = {
      extensions = [
        pkgs.vscode-extensions.continue.continue
      ];

      userSettings = {
        "yaml.schemas" = {
          "file://${config.home.homeDirectory}/.vscode/extensions/Continue.continue/config-yaml-schema.json" = [
            ".continue/**/*.yaml"
          ];
        };
      };
    };
  };
}
