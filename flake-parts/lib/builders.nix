{ withSystem, flake, inputs, ... }:
let
  mkHomeConfiguration =
    { system
    , name
    }:
    {
      ${name} = withSystem system ({ pkgs, ... }:
        inputs.home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            flake.homeModules.sharedModules
            inputs.home-manager-diff.hmModules.default
            "${flake}/home/configurations/${name}.nix"
          ];
          extraSpecialArgs = {
            inherit (inputs) nixpkgs;
            inherit flake;
          };
        });
    };
in
{
  flake.lib.builders = {
    inherit mkHomeConfiguration;
  };
}
