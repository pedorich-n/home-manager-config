{ pkgs, lib, ... }:
pkgs.linkFarm "cqlsh" [{ name = "bin/cqlsh"; path = lib.getExe' pkgs.cassandra_3_11 "cqlsh"; }]
