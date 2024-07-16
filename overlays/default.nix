inputs: _: prev:
{
  vimPlugins = prev.vimPlugins // {
    tomorrow-theme = prev.callPackage ../packages/vim-tomorrow-theme { inherit (inputs) tomorrow-theme-source; };
  };

  cqlsh = prev.callPackage ../packages/cqlsh { inherit (inputs) cqlsh-source; python3Packages = prev.python311Packages; };
}
