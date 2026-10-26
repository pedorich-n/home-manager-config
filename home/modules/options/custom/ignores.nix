{
  lib,
  ...
}:
{
  options = with lib; {
    custom.globalIgnores = mkOption {
      type = with types; listOf nonEmptyStr;
      description = "List of global ignores for all programs, like .gitignore";
    };
  };
}
