{
  config,
  lib,
  pkgs,
  ...
}:
let
  terminals = [
    "^com\\.apple\\.Terminal$"
    "^com\\.googlecode\\.iterm2$"
    "^co\\.zeit\\.hyperterm$"
    "^co\\.zeit\\.hyper$"
    "^io\\.alacritty$"
    "^org\\.alacritty$"
    "^net\\.kovidgoyal\\.kitty$"
    "^com\\.mitchellh\\.ghostty$"
  ];
  ides = [
    "^com\\.microsoft\\.VSCode"
    "^com\\.jetbrains\\."
  ];
  browsers = [
    "^org\\.mozilla\\.firefox$"
    "^org\\.mozilla\\.firefoxdeveloperedition$"
    "^org\\.mozilla\\.nightly$"
    "^com\\.microsoft\\.Edge"
    "^com\\.microsoft\\.edgemac"
    "^com\\.google\\.Chrome$"
    "^com\\.brave\\.Browser$"
    "^com\\.apple\\.Safari$"
  ];

  unless = ids: [
    {
      type = "frontmost_application_unless";
      bundle_identifiers = ids;
    }
  ];
  onlyIn = ids: [
    {
      type = "frontmost_application_if";
      bundle_identifiers = ids;
    }
  ];

  # One key press with `mandatory` modifiers (plus any others, unless `optional` says otherwise) becomes another.
  remap =
    {
      from,
      mods ? [ "control" ],
      optional ? [ "any" ],
      to ? from,
      toMods ? [ "left_command" ],
      conditions ? [ ],
    }:
    {
      type = "basic";
      from = {
        key_code = from;
        modifiers = {
          mandatory = mods;
        }
        // lib.optionalAttrs (optional != [ ]) { inherit optional; };
      };
      to = [
        {
          key_code = to;
          modifiers = toMods;
        }
      ];
    }
    // lib.optionalAttrs (conditions != [ ]) { inherit conditions; };

  run = from: mods: command: {
    type = "basic";
    from = {
      key_code = from;
      modifiers.mandatory = mods;
    };
    to = [ { shell_command = command; } ];
  };

  rule = description: manipulators: { inherit description manipulators; };

  # Ctrl+<key> -> Cmd+<key> everywhere except terminals where Ctrl keeps its Unix meaning.
  pcRule =
    description: keys:
    rule description (
      map (
        key:
        remap {
          from = key;
          conditions = unless terminals;
        }
      ) keys
    );

  browserRule =
    description: keys:
    rule description (
      map (
        key:
        remap {
          from = key;
          conditions = onlyIn browsers;
        }
      ) keys
    );
  settings = {
    profiles = [
      {
        name = "Default profile";
        selected = true;
        virtual_hid_keyboard.keyboard_type_v2 = "ansi";
        devices = [
          {
            identifiers.is_keyboard = true;
            simple_modifications = [
              {
                from.apple_vendor_top_case_key_code = "keyboard_fn";
                to = [ { key_code = "left_control"; } ];
              }
              {
                from.key_code = "left_control";
                to = [ { apple_vendor_top_case_key_code = "keyboard_fn"; } ];
              }
              {
                from.key_code = "left_option";
                to = [ { key_code = "left_command"; } ];
              }
              {
                from.key_code = "left_command";
                to = [ { key_code = "left_option"; } ];
              }
            ];
          }
          {
            identifiers = {
              is_keyboard = true;
              is_pointing_device = true;
              # Keychron K5 Pro
              vendor_id = 13364;
              product_id = 592;
            };
            ignore = false;
            treat_as_built_in_keyboard = true;
          }
          {
            identifiers = {
              is_pointing_device = true;
              # Logitech MX Master 3S
              vendor_id = 1133;
              product_id = 45108;
            };
            ignore = false;
          }
        ];

        complex_modifications.rules = [
          (rule "Ctrl+Enter as Cmd + Enter" [
            {
              type = "basic";
              from = {
                key_code = "return_or_enter";
                modifiers.mandatory = [ "right_control" ];
              };
              to = [
                {
                  key_code = "return_or_enter";
                  modifiers = [ "right_gui" ];
                  repeat = false;
                }
              ];
            }
          ])
          (rule "Ctrl + Left Click as Cmd + Left Click" [
            {
              type = "basic";
              from = {
                pointing_button = "button1";
                modifiers = {
                  mandatory = [ "left_control" ];
                  optional = [ "caps_lock" ];
                };
              };
              to = [
                {
                  pointing_button = "button1";
                  modifiers = [ "left_command" ];
                }
              ];
            }
          ])
          (rule "Terminal Copy/Paste/Cut (Ctrl+Shift+C/V/X -> Cmd+C/V/X)" (
            map
              (
                key:
                remap {
                  from = key;
                  mods = [
                    "control"
                    "shift"
                  ];
                  optional = [ ];
                  conditions = onlyIn terminals;
                }
              )
              [
                "c"
                "v"
                "x"
              ]
          ))
          (rule "PC-Style Control+Up/Down/Left/Right" (
            map
              (
                { key, toMods }:
                remap {
                  from = key;
                  inherit toMods;
                  conditions = unless terminals;
                }
              )
              [
                {
                  key = "left_arrow";
                  toMods = [ "left_option" ];
                }
                {
                  key = "right_arrow";
                  toMods = [ "left_option" ];
                }
                {
                  key = "up_arrow";
                  toMods = [ "left_command" ];
                }
                {
                  key = "down_arrow";
                  toMods = [ "left_command" ];
                }
              ]
          ))
          (rule "PC-Style Copy/Paste/Cut" (
            map
              (
                key:
                remap {
                  from = key;
                  conditions = unless (terminals ++ ides);
                }
              )
              [
                "c"
                "v"
                "x"
              ]
          ))
          (pcRule "PC-Style Undo" [ "z" ])
          (rule "PC-Style Redo" [
            (remap {
              from = "y";
              to = "z";
              toMods = [
                "left_command"
                "left_shift"
              ];
              conditions = unless terminals;
            })
          ])
          (pcRule "PC-Style Select-All" [ "a" ])
          (pcRule "PC-Style Save" [ "s" ])
          (pcRule "PC-Style New" [ "n" ])
          (rule "PC-Style Reload(F5, Ctrl+R)" [
            (remap {
              from = "r";
              conditions = unless terminals;
            })
            {
              type = "basic";
              from = {
                key_code = "f5";
                modifiers.optional = [ "any" ];
              };
              to = [
                {
                  key_code = "r";
                  modifiers = [ "left_command" ];
                }
              ];
              conditions = unless terminals;
            }
          ])
          (rule "Ctrl+Alt+T or Win+T opens Ghostty" [
            (run "t" [ "control" "option" ] "open -b com.mitchellh.ghostty")
            (run "t" [ "command" ] "open -b com.mitchellh.ghostty")
          ])
          (pcRule "PC-Style New Tab" [ "t" ])
          (pcRule "PC-Style Find" [
            "f"
            "g"
          ])
          (pcRule "PC-Style Open" [ "o" ])
          (pcRule "PC-Style Bold/Italic/Underline(Ctrl+B/I/U)" [
            "b"
            "i"
            "u"
          ])
          (pcRule "PC-Style Close Window" [ "w" ])
          (rule "PC-Style Emoji Picker (Command+.)" [
            (remap {
              from = "period";
              mods = [ "command" ];
              optional = [ ];
              to = "spacebar";
              toMods = [
                "left_control"
                "left_command"
              ];
            })
          ])
          (rule "PC-Style Switch Input (Command+Space)" [
            (remap {
              from = "spacebar";
              mods = [ "command" ];
              optional = [ ];
              toMods = [
                "left_control"
                "left_option"
              ];
            })
          ])
          (rule "PC-Style Lock Screen" [
            (remap {
              from = "l";
              mods = [ "command" ];
              optional = [ ];
              to = "power";
              toMods = [
                "left_control"
                "left_shift"
              ];
            })
          ])
          (rule "PC-Style Quit Application (Alt+F4 to Command+Q)" [
            (remap {
              from = "f4";
              mods = [ "option" ];
              optional = [ ];
              to = "q";
            })
          ])
          (rule "Control+Shift+Esc Opens Activity Monitor" [
            (run "escape" [ "control" "shift" ] "open -a 'Activity Monitor.app'")
          ])
          (browserRule "PC-Style Browser open location (Ctrl+L)" [ "l" ])
          (rule "PC-Style Back/Forward (Alt+Left Arrow/Alt+Right Arrow)" (
            map
              (
                key:
                remap {
                  from = key;
                  mods = [ "option" ];
                  conditions = onlyIn browsers;
                }
              )
              [
                "left_arrow"
                "right_arrow"
              ]
          ))
          (browserRule "PC-Style Browser Zoom (Ctrl+Plus/Minus/0)" [
            "hyphen"
            "keypad_hyphen"
            "equal_sign"
            "keypad_plus"
            "0"
            "keypad_0"
          ])
          (rule "PC-Style Control+Delete/Backspace" [
            (remap {
              from = "delete_or_backspace";
              toMods = [ "option" ];
              conditions = unless terminals;
            })
          ])
          (rule "PC-Style Control+Delete" [
            (remap {
              from = "delete_forward";
              toMods = [ "option" ];
              conditions = unless terminals;
            })
          ])
          (pcRule "PC-Style Control+K" [ "k" ])
          (rule "Win (Cmd) alone opens Spotlight" [
            {
              type = "basic";
              from = {
                key_code = "left_command";
                modifiers.optional = [ "any" ];
              };
              to = [ { key_code = "left_command"; } ];
              to_if_alone = [
                {
                  key_code = "spacebar";
                  modifiers = [ "left_command" ];
                }
              ];
            }
          ])
        ];
      }
    ];
  };

  karabinerJson = (pkgs.formats.json { }).generate "karabiner.json" settings;
  karabinerTarget = "${config.home.homeDirectory}/.config/karabiner/karabiner.json";
in
{
  # A writable copy instead of a store symlink, because Karabiner's settings app writes to this file.
  home.activation.karabiner = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    karabinerTarget=${lib.escapeShellArg karabinerTarget}
    karabinerSource=${karabinerJson}
    karabinerHash() { sha256sum < "$1" | cut -d' ' -f1; }

    if [[ -e "$karabinerTarget" ]] && [[ "$(karabinerHash "$karabinerTarget")" == "$(karabinerHash "$karabinerSource")" ]]; then
      verboseEcho "karabiner.json is up to date"
    else
      if [[ -e "$karabinerTarget" ]]; then
        run cp $VERBOSE_ARG "$karabinerTarget" "$karabinerTarget.hm-backup"
      fi
      run mkdir -p $VERBOSE_ARG "$(dirname "$karabinerTarget")"
      run install -m 600 "$karabinerSource" "$karabinerTarget"
    fi
  '';
}
