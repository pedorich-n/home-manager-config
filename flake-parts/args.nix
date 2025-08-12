{
  self,
  inputs,
  lib,
  ...
}:
let
  getName = pkg: pkg.name or pkg.meta.name or "${pkg.pname or "none"}-${pkg.version or "none"}";

  allowedInsecurePackages = [
    "openssl-1.1.1" # Dependency of Sublime Text 4
    "python-2.7" # Dependency of cqlsh (Cassandra 3.11)
  ];
in
{
  _module.args.flake = self;

  perSystem =
    { system, ... }:
    {
      _module.args = {
        pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = [
            inputs.nix-vscode-extensions.overlays.default
            inputs.rust-overlay.overlays.default
            self.overlays.default
          ];
          config = {
            allowUnfree = true;
            allowInsecurePredicate = pkg: builtins.any (prefix: lib.hasPrefix prefix (getName pkg)) allowedInsecurePackages;
          };
        };
      };
    };
}
