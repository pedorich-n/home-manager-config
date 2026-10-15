{
  self,
  inputs,
  ...
}:
{
  _module.args.flake = self;

  perSystem =
    { system, ... }:
    {
      _module.args = {
        pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = [
            self.overlays.default
            inputs.nix-vscode-extensions.overlays.default
            inputs.rust-overlay.overlays.default
          ];
          config = {
            allowUnfree = true;
            nvidia.acceptLicense = true;
          };
        };
      };
    };
}
