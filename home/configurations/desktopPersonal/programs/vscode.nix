{
  pkgs,
  ...
}:
{
  programs.vscode = {
    enable = true;
    profiles.default = {
      extensions = [
        pkgs.vscode-marketplace-release.k--kato.intellij-idea-keybindings
      ];
    };
  };
}
