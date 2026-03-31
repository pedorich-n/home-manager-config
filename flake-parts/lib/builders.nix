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
            flake.homeModules.sharedModules
            "${flake}/home/configurations/${name}.nix"
          ]
          ++ modules;
          extraSpecialArgs = {
            inherit flake inputs;
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
