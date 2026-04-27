{
  inputs,
}:
_: prev:
prev.lib.filesystem.packagesFromDirectoryRecursive {
  callPackage = prev.lib.callPackageWith (prev // { inherit inputs; });
  directory = ../packages/home-manager;
}
