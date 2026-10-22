_: _final: prev: {

  # https://github.com/NixOS/nixpkgs/pull/577232 -- drop this once it reaches nixpkgs-unstable.
  opencode = prev.opencode.overrideAttrs (
    _finalAttrs: prevAttrs: {
      installPhase =
        let
          inherit (prev) lib;

          anchor = ''wrapProgram $out/bin/opencode "''${wrapArgs[@]}"'';
          gccLibPath = lib.makeLibraryPath [
            prev.stdenv.cc.cc.lib
          ];
        in
        if !prev.stdenv.hostPlatform.isLinux then
          prevAttrs.installPhase
        else
          assert lib.hasInfix anchor prevAttrs.installPhase;
          builtins.replaceStrings
            [ anchor ]
            [
              ''
                wrapArgs+=(--prefix LD_LIBRARY_PATH : ${gccLibPath})
                wrapProgram $out/bin/opencode "''${wrapArgs[@]}"
              ''
            ]
            prevAttrs.installPhase;
    }
  );
}
