_:
{ inputs, ... }:
{

  flake = {
    overlays = {
      default = import ../overlays/default.nix inputs;
    };
  };
}
