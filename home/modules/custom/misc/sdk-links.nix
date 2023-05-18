{ lib, config, ... }:
with lib;
let
  cfg = config.custom.misc.sdkLinks;

  buildAliasPathFor = path: "${cfg.root}/${path}";
  buildAliasesForPackages = with lib.attrsets; mapAttrs' (path: source: nameValuePair (buildAliasPathFor path) { inherit source; });

in
{
  ###### interface
  options = {
    custom.misc.sdkLinks = {
      enable = mkEnableOption "SDK aliaases";

      root = mkOption {
        type = types.str;
        default = ".sdks";
        description = "Root folder for SDK links (under $HOME)";
      };

      paths = mkOption {
        type = with types; attrsOf path;
        default = { };
        description = "Arbitrary package links";
      };
    };
  };


  ###### implementation
  config = mkIf cfg.enable {
    home.file = buildAliasesForPackages cfg.paths;
  };
}
