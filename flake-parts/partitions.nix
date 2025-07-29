{ inputs, ... }: {
  imports = [
    inputs.flake-parts.flakeModules.partitions
  ];

  partitions.dev = {
    extraInputsFlake = ../dev;
    module = {
      imports = [
        ../dev/flake-module.nix
      ];

      perSystem = {
        treefmt.config = {
          projectRoot = ../.;

          settings.global.excludes = [
            # Doesn't support regex, only glob
            "**/_sources/generated.nix"
            "**/_sources/generated.json"
          ];
        };
      };
    };
  };

  partitionedAttrs = {
    devShells = "dev";
    checks = "dev";
    formatter = "dev";
  };
}
