inputs: final: prev:
{
  # TODO: delete this once https://github.com/NixOS/nixpkgs/pull/218450 gets merged
  inherit (prev.callPackage ./rtx { inherit inputs; } final prev) rtx;

  pyenv = prev.callPackage ../packages/pyenv { inherit inputs; };
  tfenv = prev.callPackage ../packages/tfenv { inherit inputs; };
  zsh-snap = prev.callPackage ../packages/zsh-snap { inherit inputs; };

  vimPlugins = prev.vimPlugins // {
    tomorrow-theme = prev.callPackage ../packages/vim-tomorrow-theme { inherit inputs; };
  };
}
