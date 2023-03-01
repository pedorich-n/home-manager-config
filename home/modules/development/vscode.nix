{ pkgs, lib, config, ... }:
{
  programs.vscode = {
    extensions = with pkgs.vscode-marketplace; [
      # Themes
      zhuangtongfa.material-theme
      matklad.pale-fire

      # Languages
      jnoortheen.nix-ide
      rust-lang.rust-analyzer
      ms-python.python
      scalameta.metals

      # Behavior
      vscodevim.vim
      wmaurer.vscode-jumpy
      k--kato.intellij-idea-keybindings
      donjayamanne.githistory
      natqe.reload
    ];

    userSettings = {
      "vim" = {
        "normalModeKeyBindingsNonRecursive" = [
          {
            "before" = [ "u" ];
            "commands" = [ "undo" ];
          }
          {
            "before" = [ "C-r" ];
            "commands" = [ "redo" ];
          }
        ];
        "useSystemClipboard" = true;
      };
      "editor" = {
        "fontFamily" = "Fira Code";
        "fontLigatures" = true;
        "fontSize" = 14;
      };
      "window" = {
        "zoomLevel" = 0.4;
      };
    };
  };
}
