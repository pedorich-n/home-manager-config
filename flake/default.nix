{ inputs }:
let
  # Copy from: https://github.com/NixOS/nixpkgs/blob/12e01c6/lib/attrsets.nix#L772-L817 with refactoring
  recursiveUpdate = with builtins; lhs: rhs:
    let
      merge = attrPath:
        zipAttrsWith (name: values:
          let here = attrPath ++ [ name ]; in
          if length values == 1 || !(isAttrs (elemAt values 0) && isAttrs (elemAt values 1))
          then
            head values
          else
            merge here values
        );
    in
    merge [ ] [ rhs lhs ];

  pkgsFor = system: pkgs:
    import pkgs {
      inherit system;
      overlays = with inputs; [ nix-vscode-extensions.overlays.default rust-overlay.overlays.default (import ../overlays inputs) ];
      config = {
        allowUnfree = true;
        allowInsecurePredicate = pkg: (builtins.match "openssl-1\.1\.1.*" pkg.pname) != [ ];
      };
    };

  customLibFor = pkgs: import ../lib { inherit pkgs; };

  formatterFor = pkgs: pkgs.nixpkgs-fmt;

  checksFor = pkgs:
    {
      pre-commit-check = inputs.pre-commit-hooks.lib.${pkgs.system}.run {
        src = ../.;
        hooks = {
          # Nix
          deadnix.enable = true;
          nixpkgs-fmt.enable = true;
          statix.enable = true;

          # Python
          black = {
            enable = true;
            entry = with pkgs; lib.mkForce "${lib.getExe black} --line-length=150";
          };
          isort.enable = true;

          # Shell
          shfmt.enable = true;
        };
      };
    };

  shellsFor = pkgs:
    let
      customLib = customLibFor pkgs;
      minimalMkShell = import ../lib/minimal-shell.nix { inherit pkgs; };

      preCommitShell = { "pre-commit" = minimalMkShell { inherit ((checksFor pkgs).pre-commit-check) shellHook; }; };
      shells = builtins.map (path: import path { inherit pkgs minimalMkShell; }) (customLib.listNixFilesRecursive ../shells);

      allShells = [ preCommitShell ] ++ shells;
    in
    customLib.flattenAttrsetsRecursive allShells;

  # Input: pkgs, attrs (schema: { <name> = <homeManagerConfigurationPath> })
  # Output: attrs (schema: { <name> = <homeManagerConfiguration> })
  homeManagerConfigurationsFor = pkgs: configurations:
    let
      customLib = customLibFor pkgs;
      sharedModules = customLib.listNixFilesRecursive ../home/modules;
      shellNamesModule = { config.custom.hm.shellNames = builtins.attrNames (shellsFor pkgs); };

      homeManagerConfigrationFor = configuration:
        inputs.home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = sharedModules ++ [ configuration shellNamesModule ];
          extraSpecialArgs = {
            inherit customLib;
            inherit (inputs) self nixpkgs;
          };
        };
    in
    builtins.mapAttrs (_: configuration: homeManagerConfigrationFor configuration) configurations;
in
{
  # Input attrs (schema: { system = { name = nixPath } })
  flakeFor = attrs:
    let
      # Input: attrs (schema: { system = { <name> = <homeManagerConfigurationPath> } })
      # Output: list of attrs (schema: { pkgs = <pkgs>; system = <system>; configurations = { <name> = <homeManagerConfigurationPath> }; })
      flatHomeConfigurationsWithPkgs = with builtins; attrValues (mapAttrs (system: configurations: { pkgs = pkgsFor system inputs.nixpkgs; inherit system configurations; }) attrs);

      # Output: attrs (schema: { formatter.${system} = <formatter>; checks.${system} = <checks>; devShells.${system} = <shells>; homeConfigurations = { <name> = <homeManagerConfiguration>; }; })
      outputsFor = { system, pkgs, configurations }: {
        formatter.${system} = formatterFor pkgs;
        checks.${system} = checksFor pkgs;
        devShells.${system} = shellsFor pkgs;
        homeConfigurations = homeManagerConfigurationsFor pkgs configurations;
      };
    in
    builtins.foldl' (acc: input: recursiveUpdate acc (outputsFor input)) { } flatHomeConfigurationsWithPkgs;
}
