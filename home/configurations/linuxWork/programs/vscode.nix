{
  pkgs,
  ...
}:
{
  programs.vscode = {
    enable = true;
    profiles.default = {
      extensions = [
        pkgs.vscode-extensions.github.copilot
      ];
    };
  };
}
