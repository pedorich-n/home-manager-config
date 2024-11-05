_: {
  perSystem = { pkgs, ... }: {
    packages = {
      bootstrap = pkgs.callPackage ../packages/bootstrap { };

      localsend = pkgs.callPackage ../packages/localsend { };

      cqlsh = pkgs.callPackage ../packages/cqlsh { };
    };
  };
}
