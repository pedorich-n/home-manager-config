{ pkgs, pkgs-unstable, lib, config, ... }:
{
  programs.vscode = {
    # VSCode from pkgs is kinda old, but the one from pkgs-unstable is broken right now :(
    package = pkgs.vscode;

    extensions = (with pkgs-unstable.vscode-extensions; [
      # Languages
      jnoortheen.nix-ide
      rust-lang.rust-analyzer
      ms-python.python
      scala-lang.scala
      scalameta.metals

      # Behavior
      vscodevim.vim
      donjayamanne.githistory
    ]) ++ (with pkgs.vscode-marketplace; [
      # Themes
      zhuangtongfa.material-theme
      matklad.pale-fire

      # Behavior
      wmaurer.vscode-jumpy
      natqe.reload
      # k--kato.intellij-idea-keybindings
    ]);

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
        "detectIndentation" = true;
        "formatOnPaste" = false;
        "formatOnType" = true;
        "formatOnSave" = true;
        "formatOnSaveMode" = "file";
        "insertSpaces" = true;
        "indentSize" = 2;
        "tabSize" = 2;
        "useTabStops" = false;
        "stickyScroll" = {
          "enabled" = true;
          "maxLineCount" = 10;
        };
      };
      "files" = {
        "encoding" = "utf8";
        "eol" = "\n";
        "insertFinalNewline" = true;
        "trimFinalNewlines" = true;
        "trimTrailingWhitespace" = true;
        "watcherExclude" = {
          "**/.ammonite" = true;
          "**/.bloop" = true;
          "**/.bsp" = true;
          "**/.history" = true;
          "**/.idea" = true;
          "**/.metals" = true;
          "**/.scala-build" = true;
          "**/.scala" = true;
          "**/metals.sbt" = true;
          "**/target" = true;
        };
      };
      "git.autofetch" = false;
      "search.exclude" = {
        "**/.ammonite" = true;
        "**/.bloop" = true;
        "**/.bsp" = true;
        "**/.history" = true;
        "**/.idea" = true;
        "**/.metals" = true;
        "**/.scala-build" = true;
        "**/.scala" = true;
        "**/metals.sbt" = true;
        "**/target" = true;
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
