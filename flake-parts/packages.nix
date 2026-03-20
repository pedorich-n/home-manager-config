{ inputs, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages = {
        bootstrap = pkgs.callPackage ../packages/bootstrap { };

        wsl-1password-cli = pkgs.callPackage ../packages/wsl-1password-cli { };

        hmd = pkgs.callPackage ../packages/hmd { };

        otto-light = pkgs.callPackage ../packages/kde-themes/otto-light.nix { inherit (inputs) otto-light-theme; };
      };
    };
}
