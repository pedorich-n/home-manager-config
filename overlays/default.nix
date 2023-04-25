inputs: final: prev:
{
  # TODO: delete this once https://github.com/NixOS/nixpkgs/pull/218450 gets merged
  inherit (prev.callPackage ./rtx { inherit inputs; } final prev) rtx;

  zsh-snap = prev.callPackage ../packages/zsh-snap { inherit inputs; };

  vimPlugins = prev.vimPlugins // {
    tomorrow-theme = prev.callPackage ../packages/vim-tomorrow-theme { inherit inputs; };
  };
}
