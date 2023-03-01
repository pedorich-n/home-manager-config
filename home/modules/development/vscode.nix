{ pkgs, pkgs-unstable, lib, config, ... }:
{
  programs.vscode = {
    # VSCode from pkgs is kinda old, but the one from pkgs-unstable is broken right now :(
    package = pkgs.vscode;

    extensions = with pkgs.vscode-marketplace; [
      # Themes
      zhuangtongfa.material-theme
      matklad.pale-fire

      # Languages
      jnoortheen.nix-ide
      pkgs.vscode-extensions.rust-lang.rust-analyzer # Needed because of older VSCode
      pkgs.vscode-extensions.ms-python.python # Needed because of older VSCode
      scalameta.metals

      # Behavior
      vscodevim.vim
      wmaurer.vscode-jumpy
      # k--kato.intellij-idea-keybindings
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
        "accessibilitySupport" = "off";
      };
      "window" = {
        "zoomLevel" = 0.6;
      };
      "workbench" = {
        "colorTheme" = "One Dark Pro Flat";
      };
    };
  };
}
