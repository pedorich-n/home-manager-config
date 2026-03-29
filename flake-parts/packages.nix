{
  perSystem =
    { pkgs, ... }:
    {
      packages = {
        bootstrap = pkgs.callPackage ../packages/bootstrap { };

        wsl-1password-cli = pkgs.callPackage ../packages/wsl-1password-cli { };

        hmd = pkgs.callPackage ../packages/hmd { };

        zsh-tab-title = pkgs.callPackage ../packages/zsh-tab-title { };
      };
    };
}
