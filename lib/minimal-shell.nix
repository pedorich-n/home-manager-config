{ pkgs }:
# From: https://fzakaria.com/2021/08/02/a-minimal-nix-shell.html / https://gist.github.com/fzakaria/68defd63f79256703a4a97772eb6f1b7
let
  stdenvMinimal = pkgs.stdenvNoCC.override {
    cc = null;
    preHook = "";
    allowedRequisites = null;
    initialPath = pkgs.lib.filter
      (a: pkgs.lib.hasPrefix "coreutils" a.name)
      pkgs.stdenvNoCC.initialPath;
    extraNativeBuildInputs = [ ];
  };
in
pkgs.mkShell.override {
  stdenv = stdenvMinimal;
}
