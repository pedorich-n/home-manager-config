{
  pkgs,
  ...
}:
{
  programs.vscode = {
    profiles.default.extensions = [
      pkgs.vscode-marketplace-release.backnotprop.plannotator-webview
    ];
  };
}
