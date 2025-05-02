{ inputs, ... }: {
  perSystem = { pkgs, ... }: {
    packages = {
      bootstrap = pkgs.callPackage ../packages/bootstrap { };

      cqlsh = pkgs.callPackage ../packages/cqlsh { inherit (inputs) nixpkgs-cassandra; };

      wsl-1password-cli = pkgs.callPackage ../packages/wsl-1password-cli { };

      hmd = pkgs.callPackage ../packages/hmd { };
    };
  };
}
