{ pkgs }:
let
  versionAttrs = {
    "0_12" = {
      version = "0.12.31";
      hash = "sha256-z50WYdLz/bOhcMT7hkgaz35y2nVho50ckK/M1TpK5g4=";
    };
    "0_15" = {
      version = "0.15.5";
      hash = "sha256-zXQv9svJXx341PFzgrApEaQ2Y38KkPlO9WxoIqhRxKE=";
    };
  };

  versions = builtins.attrNames versionAttrs;

  mkShell = attrs: pkgs.mkShell {
    nativeBuildInputs = with pkgs; [
      (mkTerraform attrs)
      saml2aws
    ];
  };
in
builtins.foldl' (acc: version: acc // { "terraform_${version}" = mkShell versionAttrs.${version}; }) { } versions
