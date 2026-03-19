{ flake, lib, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      apps =
        let
          mkBootstrap = name: {
            name = "bootstrap-${name}";
            value = {
              program = pkgs.callPackage ../packages/bootstrap { configName = name; };
            };
          };
        in
        {
          install-nix-selinux.program = pkgs.callPackage ../packages/nix-selinux/install.nix { };
        }
        // (lib.mapAttrs' (name: _: mkBootstrap name) flake.homeConfigurations);
    };
}
