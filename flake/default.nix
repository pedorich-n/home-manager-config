{ inputs }:
rec {
  customLibFor = pkgs: import ../lib { inherit pkgs; };

  pkgsFor = system: pkgs:
    let
      customOverlays = import ../overlays inputs;
    in
    import pkgs {
      inherit system;
      overlays = [ inputs.nix-vscode-extensions.overlays.default customOverlays ];
      config.allowUnfree = true;
    };

  shellsFor = system:
    let
      pkgs = pkgsFor system inputs.nixpkgs;
      customLib = customLibFor pkgs;
      minimalMkShell = import ../lib/minimal-shell.nix { inherit pkgs; };

      allShells = builtins.map (path: import path { inherit pkgs minimalMkShell; }) (customLib.listNixFilesRecursive ../shells);
    in
    customLib.flattenAttrsets allShells;

  checksFor = system:
    let
      pkgs = pkgsFor system inputs.nixpkgs;
    in
    inputs.pre-commit-hooks.lib.${system}.run {
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
      };
    };

  homeManagerConfFor = system: configuration:
    let
      pkgs = pkgsFor system inputs.nixpkgs;
      customLib = customLibFor pkgs;

      sharedModules = customLib.listNixFilesRecursive ../home/modules;
      shellNamesModule = { config.custom.hm.shellNames = builtins.attrNames (shellsFor system); };
    in
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = sharedModules ++ [ configuration shellNamesModule ];
      extraSpecialArgs = {
        inherit customLib;
        inherit (inputs) self;
      };
    };
}
