{ withSystem, flake, inputs, lib, ... }: {
  flake = {
    lib = inputs.haumea.lib.load {
      src = ../lib;
      inputs = {
        inherit inputs lib withSystem flake;
        inherit (inputs) haumea;
      };
    };
  };
}
