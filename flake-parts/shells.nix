{ flake, ... }:
{
  perSystem =
    { pkgs, lib, ... }:
    {
      /*
        Loads all shells from ../shells folder.
        Expected format of a shell: attrset containg derivations in a file
        So one file can contain multiple shells
      */
      devShells = lib.pipe ../shells [
        (src: flake.lib.loaders.listFilesRecursivelly { inherit src; })
        (builtins.map (shell: import shell { inherit pkgs lib; }))
        (lib.foldl' (acc: attrs: lib.recursiveUpdate acc attrs) { })
      ];
    };
}
