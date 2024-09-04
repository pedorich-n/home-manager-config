{ inputs, lib, ... }: {
  imports = [
    ./_options/lib.nix
  ];

  flake = {
    lib = import ../lib { inherit lib; inherit (inputs) haumea; };
  };
}
