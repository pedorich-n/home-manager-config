_:
{ inputs, lib, ... }: {
  flake = {
    lib = import ../lib { inherit lib; inherit (inputs) haumea; };
  };
}
