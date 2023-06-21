{ pkgs, config, lib, ... }:
with lib; let
  watcherExclude =
    let
      toGlobal = with strings; input: removeSuffix "/" (if (hasPrefix "**/" input) then input else "**/${input}");
    in
    with builtins; listToAttrs (map (entry: { name = toGlobal entry; value = true; }) config.custom.misc.globalIgnores);

  keymapDisableOpenTabAtIndex =
    let
      getKeyBingingFor = index:
        {
          key = "alt+${index}";
          command = "-workbench.action.openEditorAtIndex${index}";
        };
    in
    with builtins; map (index: getKeyBingingFor (toString index)) (lists.range 1 9);
in
{
  programs.vscode = {
    package = pkgs.vscode;

    extensions = (with pkgs.vscode-extensions; [
      github.copilot
    ]) ++ (with pkgs.vscode-marketplace; [
      # Themes
      evgeniypetukhov.dark-low-contrast
      dustinsanders.an-old-hope-theme-vscode
      pawelgrzybek.gatito-theme
      space-ocean-kit-refined.space-ocean-kit-refined

      # Languages
      jnoortheen.nix-ide
      mkhl.shfmt
      ms-python.isort
      ms-python.python
      rust-lang.rust-analyzer
      scala-lang.scala
      scalameta.metals
      tamasfe.even-better-toml

      # Behavior
      alefragnani.bookmarks
      cs50.vscode-presentation-mode
      donjayamanne.githistory
      fabiospampinato.vscode-open-in-github
      gruntfuggly.todo-tree
      k--kato.intellij-idea-keybindings
      natqe.reload
      shd101wyy.markdown-preview-enhanced
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
      {
        key = "alt+g";
        command = "openInGitHub.openFile";
        when = "editorTextFocus";
      }
      {
        key = "alt+2";
        command = "workbench.view.extension.bookmarks";
        when = "editorFocus";
      }
      {
        key = "alt+2";
        command = "workbench.action.toggleSidebarVisibility";
        when = "!editorFocus";
      }
    ] ++ keymapDisableOpenTabAtIndex;

    userSettings = {
      "editor.accessibilitySupport" = "off";
      "editor.cursorSurroundingLines" = 10;
      "editor.detectIndentation" = true;
      "editor.fontFamily" = "FiraCode Nerd Font";
      "editor.fontLigatures" = true;
      "editor.fontSize" = 14;
      "editor.formatOnPaste" = false;
      "editor.formatOnSave" = true;
      "editor.formatOnSaveMode" = "file";
      "editor.formatOnType" = true;
      "editor.indentSize" = 2;
      "editor.inlineSuggest.enabled" = true;
      "editor.insertSpaces" = true;
      "editor.minimap.enabled" = false;
      "editor.semanticHighlighting.enabled" = true;
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
      "files.watcherExclude" = watcherExclude;
      "git.autofetch" = false;
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "nil";
      "nix.serverSettings" = {
        "nil" = {
          "formatting" = {
            "command" = [ "nixpkgs-fmt" ];
          };
        };
      };
      "metals.enableSemanticHighlighting" = true;
      "search.useIgnoreFiles" = true;
      "search.useGlobalIgnoreFiles" = true;
      "presentation-mode.active" = {
        "commands" = [ "workbench.action.closeSidebar" ];
        "editor.fontSize" = 18;
        "editor.minimap.enabled" = false;
        "workbench.activityBar.visible" = false;
        "workbench.statusBar.visible" = false;
        "window.zoomLevel" = 2;
      };
      "presentation-mode.configBackup" = {
        "editor.fontSize" = "undefined";
        "editor.minimap.enabled" = "undefined";
        "workbench.activityBar.visible" = "undefined";
        "workbench.statusBar.visible" = "undefined";
        "window.zoomLevel" = "undefined";
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
      "window.zoomLevel" = 0.6;
      "workbench.colorTheme" = "Dark Low Contrast Fire";
    };
  };
}
