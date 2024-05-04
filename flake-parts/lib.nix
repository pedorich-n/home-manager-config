{ inputs, ... }: {
  flake = {
    lib = import ../lib { inherit (inputs.nixpkgs) lib; inherit (inputs) haumea; };
  };
}
