_:
{ inputs, ... }:
let
  pkgsFor = system: pkgs:
    import pkgs {
      inherit system;
      overlays = with inputs; [
        nix-vscode-extensions.overlays.default
        rust-overlay.overlays.default
        (import ../overlays inputs)
      ];
      config = {
        allowUnfree = true;
        allowInsecurePredicate = pkg: (builtins.match "openssl-1\.1\.1.*" pkg.pname) != [ ];
      };
    };
in
{
  perSystem = { system, ... }: {
    _module.args = {
      # pkgs with overlays and custom settings, from: https://flake.parts/overlays.html#consuming-an-overlay
      pkgs = pkgsFor system inputs.nixpkgs;
    };
  };
}
