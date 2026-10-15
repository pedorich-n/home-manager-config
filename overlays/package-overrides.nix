_: final: prev: {
  pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
    (
      _pythonFinal: pythonPrev:
      final.lib.optionalAttrs (final.stdenv.hostPlatform.isDarwin) {
        # Broken on Mac. See https://github.com/NixOS/nixpkgs/pull/572564
        debugpy = pythonPrev.debugpy.overridePythonAttrs (_oldAttrs: {
          doCheck = false;
        });
      }
    )
  ];
}
