{ pkgs, ... }:
{
  programs.vscode = {
    package = pkgs.vscode;

    extensions = (with pkgs.vscode-extensions; [
      # Languages
      # Has to be pulled from nixpkgs until this is fixed: https://github.com/nix-community/nix-vscode-extensions/issues/5
      rust-lang.rust-analyzer
    ]) ++ (with pkgs.vscode-marketplace; [
      # Themes
      matklad.pale-fire

      # Languages
      jnoortheen.nix-ide
      ms-python.python
      scala-lang.scala
      scalameta.metals
      tamasfe.even-better-toml

      # Behavior
      donjayamanne.githistory
      k--kato.intellij-idea-keybindings
      natqe.reload
      vscodevim.vim
      wmaurer.vscode-jumpy
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
      "evenBetterToml.formatter.arrayAutoCollapse" = true;
      "evenBetterToml.formatter.columnWidth" = 150;
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
      "vim.foldfix" = true;
      "vim.normalModeKeyBindingsNonRecursive" = [
        {
          "before" = [ "u" ];
          "commands" = [ "undo" ];
        }
        {
          "before" = [ "C-r" ];
          "commands" = [ "redo" ];
        }
        {
          "before" = [ "<Space>" "s" ];
          "commands" = [ "workbench.action.gotoSymbol" ];
        }
        {
          "before" = [ "<Space>" "r" ];
          "commands" = [ "editor.action.rename" ];
        }
      ];
      "vim.useSystemClipboard" = true;
      "window.newWindowDimensions" = "maximized";
      "window.openFoldersInNewWindow" = "on";
      "window.zoomLevel" = 0.8;
      "workbench.colorTheme" = "Pale Fire";
    };
  };
}
