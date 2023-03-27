{ inputs }:
rec {
  customLibFor = pkgs: import "${inputs.self}/lib/" { inherit pkgs; };

  pkgsFor = system: pkgs: import pkgs {
    inherit system;
    overlays = [ inputs.nix-vscode-extensions.overlays.default ];
    config.allowUnfree = true;
  };

  shellsFor = system:
    let
      pkgs = pkgsFor system inputs.nixpkgs;
      customLib = customLibFor pkgs;
      minimalMkShell = import "${inputs.self}/lib/minimal-shell.nix" { inherit pkgs; };

      allShells = builtins.map (path: import path { inherit pkgs minimalMkShell; }) (customLib.listNixFilesRecursive "${inputs.self}/shells/");
    in
    customLib.flattenAttrsets allShells;

  formatterPackArgsFor = system:
    let
      # As of March 2023 something in this formatter is using exteremely new packages,
      # and that results in 3GB of downloads of dependencies just to format the project
      # so I'll resort to a stable channel for doing this for now.
      pkgs = pkgsFor system inputs.nixpkgs-stable;
    in
    {
      inherit system pkgs;
      checkFiles = [ inputs.self ];
      config = {
        tools = {
          deadnix.enable = true;
          nixpkgs-fmt.enable = true;
          statix.enable = true;
        };
      };
    };

  homeManagerConfFor = system: configuration:
    let
      pkgs = pkgsFor system inputs.nixpkgs;
      customLib = customLibFor pkgs;

      sharedModules = customLib.listNixFilesRecursive "${inputs.self}/home/modules/";
      shellNamesModule = { config.custom.hm.shellNames = builtins.attrNames (shellsFor system); };
    in
    inputs.home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = sharedModules ++ [ configuration shellNamesModule ];
      extraSpecialArgs = {
        inherit customLib;
        inherit (inputs) self zsh-snap-source pyenv-source tomorrow-night-source;
      };
    };
}
