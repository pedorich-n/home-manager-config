inputs: _: prev:
{
  zsh-snap = prev.callPackage ../packages/zsh-snap { inherit (inputs) zsh-snap-source; };

  vimPlugins = prev.vimPlugins // {
    tomorrow-theme = prev.callPackage ../packages/vim-tomorrow-theme { inherit (inputs) tomorrow-theme-source; };
  };

  python3Packages = prev.python3Packages // {
    cqlsh = prev.callPackage ../packages/cqlsh { inherit (inputs) cqlsh-source; };
    hmd = prev.callPackage ../packages/hmd { };
  };

  rtx = prev.rtx.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [
      ./rtx/remove_path_shell_hook.patch
    ];
  });
}
