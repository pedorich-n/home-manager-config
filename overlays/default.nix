inputs: _: prev:
{
  zsh-snap = prev.callPackage ../packages/zsh-snap { inherit (inputs) zsh-snap-source; };

  vimPlugins = prev.vimPlugins // {
    tomorrow-theme = prev.callPackage ../packages/vim-tomorrow-theme { inherit (inputs) tomorrow-theme-source; };
  };

  github-copilot-intellij-agent = prev.callPackage ../packages/intellij-copilot { };

  python3Packages = prev.python3Packages // {
    cqlsh = prev.callPackage ../packages/cqlsh { inherit (inputs) cqlsh-source; };
    hmd = prev.callPackage ../packages/hmd { };
  };
}
