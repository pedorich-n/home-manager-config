{ pkgs, ... }:
{
  programs.vscode = {
    package = pkgs.vscode;

    extensions = (with pkgs.vscode-extensions; [
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
      matklad.pale-fire

      # Behavior
      wmaurer.vscode-jumpy
      natqe.reload
      k--kato.intellij-idea-keybindings
    ]);

    keybindings = [
      {
        key = "ctrl+`";
        command = "workbench.action.terminal.focus";
      }
      {
        key = "ctrl+`";
        command = "workbench.action.focusActiveEditorGroup";
        when = "terminalFocus";
      }
      {
        key = "shift+alt+l";
        command = "editor.action.formatDocument";
        when = "editorHasDocumentFormattingProvider && editorTextFocus && !editorReadonly && !inCompositeEditor";
      }
      {
        key = "shift+alt+f";
        command = "-editor.action.formatDocument";
        when = "editorHasDocumentFormattingProvider && editorTextFocus && !editorReadonly && !inCompositeEditor";
      }
      {
        key = "shift+alt+up";
        command = "-extension.vim_cmd+alt+up";
        when = "editorTextFocus && vim.active && !inDebugRepl";
      }
      {
        key = "shift+alt+down";
        command = "-extension.vim_cmd+alt+down";
        when = "editorTextFocus && vim.active && !inDebugRepl";
      }
    ];

    userSettings = {
      "editor.accessibilitySupport" = "off";
      "editor.cursorSurroundingLines" = 10;
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
      "python.formatting.provider" = "black";
      "python.formatting.blackArgs" = [ "--line-length=140" ];
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
      "window.openFoldersInNewWindow" = "on";
      "window.zoomLevel" = 0.8;
      "workbench.colorTheme" = "Pale Fire";
    };
  };
}
