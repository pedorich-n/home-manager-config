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
      "editor.accessibilitySupport" = "off";
      "editor.detectIndentation" = true;
      "editor.fontFamily" = "Fira Code";
      "editor.fontLigatures" = true;
      "editor.fontSize" = 14;
      "editor.formatOnPaste" = false;
      "editor.formatOnSave" = true;
      "editor.formatOnSaveMode" = "file";
      "editor.formatOnType" = true;
      "editor.indentSize" = 2;
      "editor.insertSpaces" = true;
      "editor.stickyScroll.enabled" = true;
      "editor.stickyScroll.maxLineCount" = 10;
      "editor.tabSize" = 2;
      "editor.useTabStops" = false;
      "files.encoding" = "utf8";
      "files.eol" = "\n";
      "files.insertFinalNewline" = true;
      "files.trimFinalNewlines" = true;
      "files.trimTrailingWhitespace" = true;
      "files.watcherExclude" = {
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
      "vim.normalModeKeyBindingsNonRecursive" = [
        {
          "before" = [ "u" ];
          "commands" = [ "undo" ];
        }
        {
          "before" = [ "C-r" ];
          "commands" = [ "redo" ];
        }
      ];
      "vim.useSystemClipboard" = true;
      "window.zoomLevel" = 0.6;
      "workbench.colorTheme" = "One Dark Pro Flat";
    };
  };
}
