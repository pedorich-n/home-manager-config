inputs: _: prev:
{
  vimPlugins = prev.vimPlugins // {
    tomorrow-theme = prev.callPackage ../packages/vim-tomorrow-theme { inherit (inputs) tomorrow-theme-source; };
  };

  cqlsh = prev.callPackage ../packages/cqlsh { };

  localsend-deb = prev.callPackage ../packages/localsend { };

  wsl-1password-cli = prev.callPackage ../packages/wsl-1password-cli { };
}
