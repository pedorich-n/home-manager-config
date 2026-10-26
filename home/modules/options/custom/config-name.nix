{
  lib,
  ...
}:
{
  options.custom.configName = lib.mkOption {
    type = lib.types.nonEmptyStr;
    description = "Name of this Home Manager configuration. Set automatically by the flake builder.";
  };
}
