pkg: paths: final: prev:
let
  maybeOldPostFixup = oldAttrs:
    if oldAttrs ? postFixup
    then oldAttrs.postFixup
    else "";

  commands = builtins.map (path: ''rm -f $out/${path}'') paths;
  commandsMerged = builtins.concatStringsSep "\n" commands;
in
{
  ${pkg} = prev.${pkg}.overrideAttrs (oldAttrs: rec {
    postFixup = maybeOldPostFixup oldAttrs + commandsMerged;
  });
}
