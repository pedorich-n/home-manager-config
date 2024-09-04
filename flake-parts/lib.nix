{ withSystem, inputs, lib, ... }: {
  imports = [
    ./_options/lib.nix
  ];

  flake = {
    lib = inputs.haumea.lib.load {
      src = ../lib;
      inputs = {
        inherit inputs lib withSystem;
        inherit (inputs) haumea;
      };
    };
  };
}
