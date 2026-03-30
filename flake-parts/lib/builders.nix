{
  withSystem,
  flake,
  inputs,
  ...
}:
let
  mkHomeConfiguration =
    {
      system,
      name,
      modules ? [ ],
    }:
    {
      ${name} = withSystem system (
        { pkgs, ... }:
        inputs.home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            inputs.plasma-manager.homeModules.plasma-manager
            flake.homeModules.sharedModules
            "${flake}/home/configurations/${name}.nix"
          ]
          ++ modules;
          extraSpecialArgs = {
            inherit (inputs) nixpkgs;
            inherit flake;
          };
        }
      );
    };
in
{
  flake.lib.builders = {
    inherit mkHomeConfiguration;
  };
}
