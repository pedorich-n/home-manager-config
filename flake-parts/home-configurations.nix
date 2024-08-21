{ withSystem, flake, ... }:
{ inputs, ... }:
let

  # Input: { pkgs, attrs (schema: { <name> = <homeManagerConfigurationPath> }), extraArgs }
  # Output: list of attrs (schema: { name = <name>; value = <homeManagerConfiguration> })
  homeManagerConfigurationsFor = { pkgs, configurations, extraArgs ? { } }:
    let
      homeManagerConfigrationFor = configuration:
        inputs.home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = flake.homeModules.sharedModules ++ [
            configuration
            inputs.home-manager-diff.hmModules.default
          ];
          extraSpecialArgs = {
            inherit (inputs) nixpkgs;
            inherit flake;
          } // extraArgs;
        };
    in
    pkgs.lib.mapAttrsToList (name: configuration: { inherit name; value = homeManagerConfigrationFor configuration; }) configurations;

  # Input attrs (schema: { system = { <name> = <homeManagerConfigurationPath> } })
  flakeFor = attrs:
    let
      systems = builtins.attrNames attrs;

      # Input: withSystem :: String -> ({} -> {}), https://flake.parts/module-arguments.html#withsystem
      #        It brings everything defined in `perSystem` to the scope, e.g. `pkgs`, `system`, `lib`, etc.
      # Output: attrs (schema: { <name> = <homeManagerConfiguration>; })
      homeConfigurations = withSystem:
        let
          # Output: list of attrs (schema: { name = <name>; value = <homeManagerConfiguration> })
          mkForSystem = system: withSystem system ({ pkgs, ... }:
            homeManagerConfigurationsFor { inherit pkgs; configurations = attrs.${system}; extraArgs = { }; }
          );
        in
        builtins.listToAttrs (builtins.concatMap mkForSystem systems);
    in
    {
      inherit systems;

      flake = {
        homeConfigurations = homeConfigurations withSystem;
      };
    };
in
flakeFor {
  "x86_64-linux" = {
    wslPersonal = ../home/configurations/wsl-personal.nix;
    linuxMinimal = ../home/configurations/linux-minimal.nix;
    linuxWork = ../home/configurations/linux-work.nix;
  };
}
