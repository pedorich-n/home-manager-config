pkg: paths: _final: prev:
let
  maybeOldPostFixup = oldAttrs: oldAttrs.postFixup or "";

  commands = builtins.map (path: ''rm -f $out/${path}'') paths;
  commandsMerged = builtins.concatStringsSep "\n" commands;
in
{
  ${pkg} = prev.${pkg}.overrideAttrs (oldAttrs: rec {
    postFixup = maybeOldPostFixup oldAttrs + commandsMerged;
  });
}
