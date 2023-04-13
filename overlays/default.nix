inputs:
let
  # Pass flake inputs to overlay so we can use the sources pinned in flake.lock
  # instead of having to keep sha256 hashes in each package for src
  inherit inputs;
in
_self: super: {
  pyenv = super.callPackage ../packages/pyenv { inherit inputs; };
  tfenv = super.callPackage ../packages/tfenv { inherit inputs; };
}
