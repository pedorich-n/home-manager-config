{ pkgs, lib, config, ... }:
let
  cfg = config.custom.programs.python;
in
{
  ###### interface
  options = with lib; {
    custom.programs.python = {
      enable = mkEnableOption "Python";

      package = mkPackageOption pkgs "python3" { };

      extraPackages = mkOption {
        type = types.functionTo (types.listOf types.package);
        default = _: [ ];
        defaultText = literalExpression ''
          python3Packages: with python3Packages; [];
        '';
        example = literalExpression ''
          python3Packages: with python3Packages; [
            requests
          ];
        '';
        description = "Extra Python packages to install";
      };
    };
  };


  ###### implementation
  config =
    let
      pythonPackage = cfg.package.withPackages (ps: with ps; [
        mypy # static type checker
        pip # package manager
        setuptools # utilities
        virtualenv # virtual environment manager
      ] ++ (cfg.extraPackages ps));

      poetryPackage = pkgs.poetry.withPlugins (ps: with ps; [
        poetry-plugin-up # Poetry plugin to simplify package updates
        poetry-plugin-export # Poetry plugin to export the dependencies to various formats
      ]);

    in
    lib.mkIf cfg.enable {
      home.packages = [
        pythonPackage # python with packages
        poetryPackage # package manager with plugins
        pkgs.ruff # linter & formatter
      ];
    };
}
