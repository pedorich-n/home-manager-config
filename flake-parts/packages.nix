_:
_: {

  perSystem = { pkgs, ... }: {
    packages = {
      bootstrap = pkgs.callPackage ../packages/bootstrap { };

      localsend = pkgs.callPackage ../packages/localsend { };
    };
  };
}
