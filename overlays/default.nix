inputs: final: prev:
{
  # TODO: delete this once https://github.com/NixOS/nixpkgs/pull/218450 gets merged
  rtx = prev.callPackage ./rtx { inherit (inputs) rtx-flake; } final prev;

  zsh-snap = prev.callPackage ../packages/zsh-snap { inherit (inputs) zsh-snap-source; };

  vimPlugins = prev.vimPlugins // {
    tomorrow-theme = prev.callPackage ../packages/vim-tomorrow-theme { inherit (inputs) tomorrow-theme-source; };
  };

  github-copilot-intellij-agent = prev.callPackage ../packages/intellij-copilot { };

  cqlsh = prev.callPackage ../packages/cqlsh { inherit (inputs) cqlsh-source; };
}
