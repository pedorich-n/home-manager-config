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
        directory = ../pkgs/tools;
      };

      mkBootstrap = name: {
        name = "bootstrap-${name}";
        value = {
          program = tools.hm-bootstrap.override { configName = name; };
        };
      };

      bootstrapApps = lib.mapAttrs' (name: _: mkBootstrap name) flake.homeConfigurations;
    in
    {
      apps = {
        install-nix-selinux.program = tools.nix-selinux.install;
      }
      // bootstrapApps;
    };
}
