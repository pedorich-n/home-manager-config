{ flake, ... }:
{ lib, ... }: {
  perSystem = { pkgs, ... }: {
    apps =
      let
        mkBootstrap = name: { name = "bootstrap-${name}"; value = { program = pkgs.callPackage ../packages/bootstrap { configName = name; }; }; };
      in
      lib.mapAttrs' (name: _: mkBootstrap name) flake.homeConfigurations;
  };
}
