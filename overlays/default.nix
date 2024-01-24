inputs: _: prev:
{
  vimPlugins = prev.vimPlugins // {
    tomorrow-theme = prev.callPackage ../packages/vim-tomorrow-theme { inherit (inputs) tomorrow-theme-source; };
  };

  python3Packages = prev.python3Packages // {
    cqlsh = prev.callPackage ../packages/cqlsh { inherit (inputs) cqlsh-source; };
  };
}
