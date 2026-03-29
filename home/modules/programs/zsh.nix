{
  config,
  pkgs,
  lib,
  ...
}:
let

  zsh-tab-title = pkgs.fetchurl {
    url = "https://github.com/trystan2k/zsh-tab-title/blob/v3.4.0/zsh-tab-title.plugin.zsh";
    sha256 = "sha256-XKRLbay+c5e5UIUM96VNcnX0SOGDx1UOdxXjF4uaByQ=";
  };

  omzLibs = builtins.map (file: "source ${pkgs.oh-my-zsh}/share/oh-my-zsh/lib/${file}.zsh") [
    "completion"
    "functions"
    "git"
    "key-bindings"
  ];

  omzPlugins =
    builtins.map
      (file: {
        name = file;
        src = "${pkgs.oh-my-zsh}/share/oh-my-zsh/plugins/${file}";
      })
      [
        "extract"
        "git"
      ];
in
{
  programs.zsh = {

    enableCompletion = lib.mkDefault true;

    dotDir = lib.mkDefault "${config.xdg.configHome}/zsh";

    history = {
      append = lib.mkDefault true; # Append history, rather than replace it. Multiple parallel zsh sessions will all write history to the histfile
      ignoreAllDups = lib.mkDefault true; # Delete old recorded entry if new entry is a duplicate.
      ignoreDups = lib.mkDefault true; # Don't record an entry that was just recorded again.
      ignoreSpace = lib.mkDefault true; # Don't record an entry starting with a space.
      share = lib.mkDefault true; # Share history between all sessions.
    };

    initContent = lib.mkMerge [
      (lib.mkOrder 850 (lib.concatLines omzLibs))
      (lib.mkOrder 1200 ''
        set +o histexpand # Disable history expantion (annying exclamantion mark behaviour)

        zstyle ':completion:*' menu yes select _complete _ignored _approximate _files

        setopt MENU_COMPLETE # On ambiguous completion insert first match and show menu
        setopt HIST_REDUCE_BLANKS # Remove superfluous blanks from history
        unsetopt EXTENDED_GLOB # Don't treat the '#', '~' and '^' characters as part of patterns for filename generation, etc.

        include () {
            [[ -f "$1" ]] && source "$1"
        }

        include "${config.home.homeDirectory}/.zshrc_extra";
      '')
    ];

    plugins = omzPlugins ++ [
      {
        name = "zsh-tab-title";
        src = zsh-tab-title;
      }
    ];
  };
}
