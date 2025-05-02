inputs: _: prev:
{
  vimPlugins = prev.vimPlugins // {
    tomorrow-theme = prev.callPackage ../packages/vim-tomorrow-theme { inherit (inputs) tomorrow-theme-source; };
  };

  cqlsh = prev.callPackage ../packages/cqlsh { inherit (inputs) nixpkgs-cassandra; };

  wsl-1password-cli = prev.callPackage ../packages/wsl-1password-cli { };

  hmd = prev.callPackage ../packages/hmd { };
}
