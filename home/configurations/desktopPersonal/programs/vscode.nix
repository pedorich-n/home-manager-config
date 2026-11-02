{
  pkgs,
  ...
}:
{
  programs.vscode = {
    enable = true;
    profiles.default = {
      extensions = with pkgs.vscode-marketplace-release; [
        k--kato.intellij-idea-keybindings
        backnotprop.plannotator-webview
      ];
    };
  };
}
