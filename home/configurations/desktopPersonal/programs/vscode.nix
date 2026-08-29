{
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
    };
  };
}
