{
  lib,
  ...
}:
{
  options = with lib; {
    custom.misc.globalIgnores = mkOption {
      type = with types; listOf nonEmptyStr;
      description = "List of global ignores for all programs, like .gitignore";
    };
  };

}
