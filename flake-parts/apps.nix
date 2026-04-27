{
  flake,
  ...
}:
{
  perSystem =
    {
      pkgs,
      lib,
      ...
    }:
    let
      tools = lib.filesystem.packagesFromDirectoryRecursive {
        inherit (pkgs) callPackage;
        directory = ../packages/tools;
      };

      mkBootstrap = name: {
        name = "bootstrap-${name}";
        value = {
          program = tools.bootstrap.override { configName = name; };
        };
      };
    in
    {
      apps = {
        install-nix-selinux.program = tools.nix-selinux.install;
      }
      // (lib.mapAttrs' (name: _: mkBootstrap name) flake.homeConfigurations);
    };
}
