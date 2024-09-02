{ inputs, lib, ... }: {
  imports = [
    ./_modules/lib.nix
  ];

  flake = {
    lib = import ../lib { inherit lib; inherit (inputs) haumea; };
  };
}
