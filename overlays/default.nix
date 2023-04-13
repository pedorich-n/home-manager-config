inputs: _final: prev: {
  pyenv = prev.callPackage ../packages/pyenv { inherit inputs; };
  tfenv = prev.callPackage ../packages/tfenv { inherit inputs; };
  zsh-snap = prev.callPackage ../packages/zsh-snap { inherit inputs; };
}
