{ pkgs, config, lib, ... }:
let
  watcherExclude =
    let
      toGlobal = input: lib.strings.removeSuffix "/" (if (lib.strings.hasPrefix "**/" input) then input else "**/${input}");
    in
    lib.foldl' (acc: entry: acc // { ${toGlobal entry} = true; }) { } config.custom.misc.globalIgnores;

  keymapDisableOpenTabAtIndex =
    let
      getKeyBingingFor = index:
        {
          key = "alt+${index}";
          command = "-workbench.action.openEditorAtIndex${index}";
        };
    in
    builtins.map (index: getKeyBingingFor (builtins.toString index)) (lib.lists.range 1 9);
in
{
  programs.vscode = {
    package = pkgs.vscode;

    profiles.default = {

      extensions = (with pkgs.vscode-extensions; [
        # Using those from nixpkgs, because they require extra setup which is not provivided in vscode-marketplace
        github.copilot
        jebbs.plantuml
        hashicorp.terraform
      ]) ++ (with pkgs.vscode-marketplace; [
        # Themes
        evgeniypetukhov.dark-low-contrast
        dustinsanders.an-old-hope-theme-vscode
        pawelgrzybek.gatito-theme
        space-ocean-kit-refined.space-ocean-kit-refined

        # Languages
        arrterian.nix-env-selector
        charliermarsh.ruff
        jnoortheen.nix-ide
        kdl-org.kdl
        mads-hartmann.bash-ide-vscode
        mkhl.shfmt
        rust-lang.rust-analyzer
        scala-lang.scala
        scalameta.metals
        skellock.just
        tamasfe.even-better-toml
        redhat.vscode-yaml
        ms-azuretools.vscode-docker
        ms-python.python
        ms-python.vscode-pylance
        wholroyd.jinja

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
        editorconfig.editorconfig
        esbenp.prettier-vscode
        exodiusstudios.comment-anchors
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
          key = "alt+1";
          command = "workbench.view.explorer";
          when = "!view.workbench.explorer.fileView.visible";
        }
        {
          key = "alt+1";
          command = "workbench.action.toggleSidebarVisibility";
          when = "view.workbench.explorer.fileView.visible";
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

      userSettings =
        let
          editorSettings = {
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
          };

          filesSettings = {
            "files.autoSave" = "afterDelay";
            "files.encoding" = "utf8";
            "files.eol" = "\n";
            "files.insertFinalNewline" = true;
            "files.trimFinalNewlines" = true;
            "files.trimTrailingWhitespace" = true;
            "files.watcherExclude" = watcherExclude;
            "files.associations" = {
              "*.uml" = "plantuml";
            };
          };

          nixSettings = {
            "nix.enableLanguageServer" = true;
            "nix.serverPath" = "nil";
            "nix.serverSettings" = {
              "nil" = {
                "formatting" = {
                  "command" = [ "nixpkgs-fmt" ];
                };
              };
            };
          };

          presentationModeSettings = {
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
          };

          pythonSettings = {
            "ruff.lineLength" = 140;
            "[python]" = {
              "editor.defaultFormatter" = "charliermarsh.ruff";
            };
          } // (lib.optionalAttrs config.custom.programs.python.enable {
            "python.defaultInterpreterPath" = lib.getExe config.custom.programs.python.resultEnv;
          });

          scalaSettings = {
            "metals.enableSemanticHighlighting" = true;
          };

          tomlSettings = {
            "evenBetterToml.formatter.arrayAutoCollapse" = true;
            "evenBetterToml.formatter.columnWidth" = 150;
          };

          vimSettings = {
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
          };

          vscodeMiscSettings = {
            "extensions.autoUpdate" = false;
            "git.autofetch" = false;
            "search.useIgnoreFiles" = true;
            "search.useGlobalIgnoreFiles" = true;
            "terminal.integrated.fontFamily" = "FiraCode Nerd Font";
            "window.newWindowDimensions" = "maximized";
            "window.openFoldersInNewWindow" = "on";
            "window.zoomLevel" = 0.6;
            "workbench.colorTheme" = "Dark Low Contrast Fire";
            "workbench.editor.wrapTabs" = true;
          };

          yamlSettings = {
            "[yaml]" = {
              "editor.defaultFormatter" = "redhat.vscode-yaml";
            };
          };

          jsonSettings = {
            "[json]" = {
              "editor.defaultFormatter" = "esbenp.prettier-vscode";
            };
          };

        in
        editorSettings //
        filesSettings //
        nixSettings //
        presentationModeSettings //
        pythonSettings //
        scalaSettings //
        tomlSettings //
        vimSettings //
        vscodeMiscSettings //
        yamlSettings //
        jsonSettings;
    };
  };

}
