{
  perSystem =
    { pkgs, ... }:
    {
      packages = {
        bootstrap = pkgs.callPackage ../packages/bootstrap { };

        wsl-1password-cli = pkgs.callPackage ../packages/wsl-1password-cli { };

        hmd = pkgs.callPackage ../packages/hmd { };
      };
    };
}
